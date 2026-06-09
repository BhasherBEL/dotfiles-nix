{
  lib,
  config,
  inputs,
  ...
}:
let
  cfg = config.hostServices.maas-rs;
in
{
  imports = [
    inputs.maas-rs.nixosModule
  ];

  options = {
    hostServices.maas-rs = {
      enable = lib.mkEnableOption "Enable maas-rs server";
      fqdn = lib.mkOption {
        type = lib.types.str;
        default = "routing.bhasher.com";
        description = "The hostname for maas-rs";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets = {
      "services/maas-rs/BMC_PARTNER_KEY" = {
        owner = config.users.users.maas-rs.name;
        group = config.users.groups.maas-rs.name;
      };
    };
    services = {
      maas-rs = {
        enable = true;
        dataDir = "/var/lib/maas-rs";

        settings = {
          build = {
            inputs = [
              {
                ingestor = "osm/pbf";
                url = "path:data/belgium-latest.osm.pbf";
              }
              {
                ingestor = "gtfs/stib";
                name = "STIB";
                url = "https://api-management-opendata-production.azure-api.net/api/gtfs/feed/stibmivb/static/";
                headers = {
                  Cache-Control = "no-cache";
                  bmc-partner-key = "\${file:${config.sops.secrets."services/maas-rs/BMC_PARTNER_KEY".path}}";
                };
              }
              {
                ingestor = "gtfs/sncb";
                name = "SNCB";
                url = "https://api-management-opendata-production.azure-api.net/api/gtfs/feed/nmbssncb/static/";
                osm_url = "path:data/belgium-latest.osm.pbf";
                headers = {
                  Cache-Control = "no-cache";
                  bmc-partner-key = "\${file:${config.sops.secrets."services/maas-rs/BMC_PARTNER_KEY".path}}";
                };
              }
            ];
            output = "graph.bin";
            osm_output = "osm.bin";

            delay_models = [
              {
                mode = "subway";
                bins = [
                  [
                    (-120)
                    0.01
                  ]
                  [
                    (-60)
                    0.02
                  ]
                  [
                    0
                    0.08
                  ]
                  [
                    60
                    0.22
                  ]
                  [
                    120
                    0.50
                  ]
                  [
                    180
                    0.80
                  ]
                  [
                    240
                    0.91
                  ]
                  [
                    300
                    0.96
                  ]
                  [
                    420
                    0.98
                  ]
                  [
                    600
                    0.99
                  ]
                  [
                    900
                    1.00
                  ]
                ];
              }
              {
                mode = "tram";
                bins = [
                  [
                    (-300)
                    0.02
                  ]
                  [
                    (-120)
                    0.08
                  ]
                  [
                    (-60)
                    0.15
                  ]
                  [
                    0
                    0.55
                  ]
                  [
                    60
                    0.67
                  ]
                  [
                    120
                    0.76
                  ]
                  [
                    180
                    0.83
                  ]
                  [
                    300
                    0.90
                  ]
                  [
                    600
                    0.96
                  ]
                  [
                    900
                    0.98
                  ]
                  [
                    1800
                    1.00
                  ]
                ];
              }
              {
                mode = "bus";
                bins = [
                  [
                    (-300)
                    0.03
                  ]
                  [
                    (-120)
                    0.09
                  ]
                  [
                    (-60)
                    0.16
                  ]
                  [
                    0
                    0.45
                  ]
                  [
                    60
                    0.58
                  ]
                  [
                    120
                    0.67
                  ]
                  [
                    180
                    0.74
                  ]
                  [
                    300
                    0.84
                  ]
                  [
                    600
                    0.93
                  ]
                  [
                    900
                    0.97
                  ]
                  [
                    1800
                    1.00
                  ]
                ];
              }
              {
                mode = "rail";
                bins = [
                  [
                    (-300)
                    0.04
                  ]
                  [
                    (-120)
                    0.10
                  ]
                  [
                    (-60)
                    0.17
                  ]
                  [
                    0
                    0.62
                  ]
                  [
                    60
                    0.70
                  ]
                  [
                    120
                    0.77
                  ]
                  [
                    180
                    0.82
                  ]
                  [
                    300
                    0.88
                  ]
                  [
                    360
                    0.90
                  ]
                  [
                    600
                    0.94
                  ]
                  [
                    900
                    0.97
                  ]
                  [
                    1800
                    0.99
                  ]
                  [
                    3600
                    1.00
                  ]
                ];
              }
            ];
          };
          log_level = "debug";
          default_routing = { };
          server = {
            host = "127.0.0.1";
            port = 3000;
          };
          auto_update = {
            enable = true;
            schedule = "0 5 * * * *";
            cache_dir = "cache";
          };
          realtime = {
            enabled = false;
          };
        };
      };
      nginx.virtualHosts = {
        "${cfg.fqdn}" = {
          forceSSL = true;
          enableACME = true;
          locations = {
            "/" = {
              recommendedProxySettings = true;
              proxyPass = "http://127.0.0.1:3000";
            };
          };
        };
      };
    };

    environment.persistence."/persistent" = {
      enable = lib.mkDefault false;
      directories = [
        {
          directory = "/var/lib/maas-rs";
          user = config.users.users.maas-rs.name;
          group = config.users.groups.maas-rs.name;
        }
      ];
    };

    hostServices.restic.paths = [ "/persistent/var/lib/maas-rs" ];
  };
}
