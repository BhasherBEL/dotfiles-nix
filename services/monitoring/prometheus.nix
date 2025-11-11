{ lib, config, ... }:
{
  options = {
    hostServices.monitoring.prometheus.enable = lib.mkEnableOption "Enable Prometheus monitoring service";
  };

  config = lib.mkIf config.hostServices.monitoring.prometheus.enable {
    services = {
      prometheus = {
        enable = true;
        stateDir = "prometheus";

        exporters.node.enable = true;

        globalConfig.scrape_interval = "30s";
        scrapeConfigs = [
          {
            job_name = "node";
            static_configs = [
              {
                targets = [
                  "127.0.0.1:${toString config.services.prometheus.exporters.node.port}"
                ];
              }
            ];
          }
        ];
      };
      nginx.virtualHosts."prometheus.laptop.local.bhasher.com" = {
        # enableACME = true;
        # forceSSL = true;
        locations."/" = {
          recommendedProxySettings = true;
          proxyPass = "http://127.0.0.1:${toString config.services.prometheus.port}";
        };
      };
    };

    environment.persistence."/persistent" = {
      enable = lib.mkDefault false;
      directories = [
        "/var/lib/prometheus"
      ];
    };

    hostServices.restic.paths = [ "/persistent/var/lib/prometheus" ];
  };
}
