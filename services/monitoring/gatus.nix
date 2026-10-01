{ lib, config, ... }:
let
  cfg = config.hostServices.monitoring.gatus;
in
{
  options = {
    hostServices.monitoring.gatus = {
      enable = lib.mkEnableOption "Enable gatus service";
      hostname = lib.mkOption {
        type = lib.types.str;
        default = "status.bhasher.com";
        description = "The hostname for gratus";
      };
      endpoints = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "URLs to probe; alert if they don't return 200";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets."services/gatus/env" = {
      mode = "0444";
    };

    services = {
      gatus = {
        enable = true;
        environmentFile = config.sops.secrets."services/gatus/env".path;
        settings = {
          alerting.ntfy = {
            url = "https://ntfy.sh";
            topic = "\${NTFY_TOPIC}";
            default-alert = {
              failure-threshold = 3;
              success-threshold = 3;
              send-on-resolved = true;
            };
          };
          web.port = 61303;
          storage = {
            type = "sqlite";
            path = "/var/lib/gatus/data.db";
          };
          endpoints = [
            {
              name = "snc-ping";
              group = "mail";
              url = "icmp://37.120.190.20";
              interval = "1m";
              conditions = [ "[CONNECTED] == true" ];
              alerts = [ { type = "ntfy"; } ];
            }
            {
              name = "snc-smtp";
              group = "mail";
              url = "starttls://mail01.bhasher.com:25";
              interval = "1m";
              conditions = [
                "[CONNECTED] == true"
                "[CERTIFICATE_EXPIRATION] > 336h"
              ];
            }
          ]
          ++ map (url: {
            name = builtins.head (builtins.match "https?://([^/]+).*" url);
            group = "services";
            inherit url;
            interval = "1m";
            conditions = [ "[STATUS] == 200" ];
            alerts = [ { type = "ntfy"; } ];
          }) cfg.endpoints;

          external-endpoints = [
            {
              name = "snc-backup";
              token = "\${GATUS_PUSH_TOKEN}";
              heartbeat.interval = "26h";
              alerts = [
                {
                  type = "ntfy";
                  failure-threshold = 1;
                  success-threshold = 1;
                }
              ];
            }
            {
              name = "shp-backup";
              token = "\${GATUS_PUSH_TOKEN}";
              heartbeat.interval = "26h";
              alerts = [
                {
                  type = "ntfy";
                  failure-threshold = 1;
                  success-threshold = 1;
                }
              ];
            }
            {
              name = "snc-queue";
              group = "mail";
              token = "\${GATUS_PUSH_TOKEN}";
              heartbeat.interval = "30m";
              alerts = [
                {
                  type = "ntfy";
                  failure-threshold = 1;
                }
              ];
            }
          ];
        };
      };

      nginx.virtualHosts."${cfg.hostname}" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          recommendedProxySettings = true;
          proxyPass = "http://127.0.0.1:${toString config.services.gatus.settings.web.port}";
        };
      };
    };

    networking.firewall.interfaces.wg0.allowedTCPPorts = [
      config.services.gatus.settings.web.port
    ];

    environment.persistence."/persistent" = {
      enable = lib.mkDefault false;
      directories = [
        {
          directory = "/var/lib/private/gatus";
          mode = "0700";
        }
      ];
    };

    hostServices.restic.paths = [ "/persistent/var/lib/private/gatus" ];
  };
}
