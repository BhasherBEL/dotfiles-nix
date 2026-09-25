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
          endpoints = map (url: {
            name = builtins.head (builtins.match "https?://([^/]+).*" url);
            inherit url;
            interval = "1m";
            conditions = [ "[STATUS] == 200" ];
            alerts = [ { type = "ntfy"; } ];
          }) cfg.endpoints;
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
  };
}
