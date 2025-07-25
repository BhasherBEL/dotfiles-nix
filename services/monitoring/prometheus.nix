{ lib, config, ... }:
{
  options = {
    hostServices.monitoring.prometheus.enable = lib.mkEnableOption "Enable Prometheus monitoring service";
  };

  config = lib.mkIf config.hostServices.monitoring.prometheus.enable {
    services.prometheus = {
      enable = true;

      exporters.node.enable = true;

      globalConfig.scrape_interval = "1m";
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
  };
}
