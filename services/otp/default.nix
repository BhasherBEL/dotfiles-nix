{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.hostServices.otp;

  builderScript = pkgs.writeShellScript "otp-build" ''
    set -euo pipefail
    mkdir -p ${cfg.cacheDir}
    cd ${cfg.cacheDir}

    # Download OSM
    ${lib.concatMapStrings (s: ''
      	${pkgs.curl}/bin/curl -fL --etag-compare "${s.filename}.etag" --etag-save "${s.filename}.etag" \
      		-o "${s.filename}" "${s.url}"
    '') cfg.osmSources}

    # Download GTFS
    ${lib.concatMapStrings (s: ''
      	${pkgs.curl}/bin/curl -fL --etag-compare "${s.filename}.etag" --etag-save "${s.filename}.etag" \
      		-o "${s.filename}" "${s.url}"
    '') cfg.gtfsSources}

    # Write configs
    cat > build-config.json <<'EOF'
    ${builtins.toJSON cfg.buildCfg}
    EOF

    cat > otp-config.json <<'EOF'
    ${builtins.toJSON cfg.runtimeCfg}
    EOF

    # Build graph
    ${pkgs.opentripplanner}/bin/opentripplanner \
    	--build ${cfg.cacheDir} --save
  '';

in
{
  options = {
    hostServices.otp = {
      enable = lib.mkEnableOption "Enable OpenTripPlanner";
      hostname = lib.mkOption {
        type = lib.types.str;
        default = "maps.bhasher.com";
        description = "The hostname for otp";
      };
      cacheDir = lib.mkOption {
        type = lib.types.str;
        default = "/var/cache/otp";
        description = "OpenTripPlanner cache directory";
      };

      osmSources = lib.mkOption {
        type = lib.types.listOf (
          lib.types.submodule {
            options = {
              url = lib.mkOption {
                type = lib.types.str;
                description = "OSM/PBF URL";
              };
              filename = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
                description = "Filename to save as (defaults to basename of URL)";
              };
            };
          }
        );
        default = [
          {
            url = "https://download.geofabrik.de/europe/belgium-latest.osm.pbf";
            filename = "belgium-latest.osm.pbf";
          }
        ];
        description = "List of OSM/PBF sources with optional static filenames.";
      };

      gtfsSources = lib.mkOption {
        type = lib.types.listOf (
          lib.types.submodule {
            options = {
              url = lib.mkOption {
                type = lib.types.str;
                description = "GTFS feed URL";
              };
              filename = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
                description = "Filename to save as (defaults to basename of URL)";
              };
            };
          }
        );
        default = [
          {
            url = "https://sncb-opendata.hafas.de/gtfs/static/c21ac6758dd25af84cca5b707f3cb3de";
            filename = "sncb-gtfs.zip";
          }
          {
            url = "https://opendata.tec-wl.be/Current%20GTFS/TEC-GTFS.zip";
            filename = "tec-gtfs.zip";
          }
          {
            url = "https://data.stib-mivb.brussels/api/explore/v2.1/catalog/datasets/gtfs-routes-production/alternative_exports/gtfszip/";
            filename = "stib-gtfs.zip";
          }
        ];
        description = "List of GTFS sources with optional static filenames.";
      };

      buildCfg = lib.mkOption {
        type = lib.types.attrs;
        default = {
          writeCachedElevations = true;
          staticBikeParkAndRide = true;
          staticParkAndRide = true;
          emission = {
            carAvgCo2PerKm = 120;
            carAvgOccupancy = 1.25;
          };
          osm = [
            { source = "belgium-latest.osm.pbf"; }
          ];
          transitFeeds = [
            {
              type = "gtfs";
              feedId = "sncb";
              source = "sncb-gtfs.zip";
            }
            {
              type = "gtfs";
              feedId = "tec";
              source = "tec-gtfs.zip";
            }
            {
              type = "gtfs";
              feedId = "stib";
              source = "stib-gtfs.zip";
            }
          ];
        };
        description = "Build configuration passed to OTP graph builder (embedded as JSON).";
      };

      runtimeCfg = lib.mkOption {
        type = lib.types.attrs;
        default = {
          server = {
            port = 44028;
          };
          otpFeatures = {
            FaresV2 = true;
            SandboxAPIGeocoder = true;
            SandboxAPIMapboxVectorTilesApi = true;
            ParallelRouting = true;
            Co2Emissions = true;
          };
          Co2Emissions = true;
        };
        description = "Runtime (otp-config) configuration";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    users.groups.otp = { };
    users.users.otp = {
      isSystemUser = true;
      group = "otp";
      home = cfg.cacheDir;
    };

    systemd = {
      tmpfiles.rules = [
        "d ${cfg.cacheDir} 0755 otp otp -"
      ];

      services = {
        otp-builder = {
          description = "Build OpenTripPlanner graph";
          after = [ "network-online.target" ];
          wants = [ "network-online.target" ];
          serviceConfig = {
            Type = "oneshot";
            User = "otp";
            Group = "otp";
            WorkingDirectory = cfg.cacheDir;
            ExecStart = builderScript;
            # ExecStartPost = "${pkgs.systemd}/bin/systemctl restart otp-runner.service";
          };
          wantedBy = [ "multi-user.target" ];
        };

        otp-runner = {
          description = "OpenTripPlanner server";
          after = [
            "network-online.target"
            "otp-builder.service"
          ];
          wants = [ "network-online.target" ];
          serviceConfig = {
            Type = "simple";
            User = "otp";
            Group = "otp";
            WorkingDirectory = cfg.cacheDir;
            ExecStart = ''
              ${pkgs.opentripplanner}/bin/opentripplanner \
                --load ${cfg.cacheDir} \
                --serve \
                --port ${toString cfg.runtimeCfg.server.port}
            '';
            Restart = "on-failure";
            RestartSec = 5;
          };
          wantedBy = [ "multi-user.target" ];
        };
      };
      timers.otp-builder = {
        wantedBy = [ "timers.target" ];
        partOf = [ "otp-builder.service" ];
        timerConfig = {
          OnCalendar = "weekly";
          Persistent = true;
        };
      };
    };

    services = {
      nginx.virtualHosts."${cfg.hostname}" = {
        forceSSL = true;
        enableACME = true;
        locations = {
          "/" = {
            proxyPass = "http://127.0.0.1:${toString cfg.runtimeCfg.server.port}";
            recommendedProxySettings = true;
          };
        };
      };
    };

    environment.persistence."/persistent" = {
      enable = lib.mkDefault false;
      directories = [
        "/var/cache/otp"
      ];
    };
  };
}
