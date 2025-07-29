{ lib, config, ... }:
{
  options = {
    hostServices.mediaserver.servarr.enable = lib.mkEnableOption "Enable Servarr";
  };

  config = lib.mkIf config.hostServices.mediaserver.servarr.enable {
    sops.secrets = {
      "services/radarr/apiKey" = {
        group = config.users.groups.media.name;
      };
    };

    services = {
      radarr = {
        enable = true;
        dataDir = "/var/lib/radarr";
        group = "media";
      };
      sonarr = {
        enable = true;
        dataDir = "/var/lib/sonarr";
        group = "media";
      };
      prowlarr = {
        enable = true;
        dataDir = "/var/lib/prowlarr";
        # group = "media";
      };
      bazarr = {
        enable = true;
        dataDir = "/var/lib/bazarr";
        group = "media";
      };

      prometheus = {
        exporters = {
          exportarr-radarr = {
            enable = config.hostServices.mediaserver.analytics;
            url = "http://127.0.0.1:${toString config.services.radarr.settings.server.port}";
            listenAddress = "127.0.0.1";
            apiKeyFile = "/run/secrets/services/radarr/apiKey";
          };
          exportarr-sonarr = {
            # enable = config.hostServices.mediaserver.analytics;
            url = "http://127.0.0.1:${toString config.services.sonarr.settings.server.port}";
            listenAddress = "127.0.0.1";
          };
          exportarr-prowlarr = {
            # enable = config.hostServices.mediaserver.analytics;
            url = "http://127.0.0.1:${toString config.services.prowlarr.settings.server.port}";
            listenAddress = "127.0.0.1";
          };
          exportarr-bazarr = {
            # enable = config.hostServices.mediaserver.analytics;
            url = "http://127.0.0.1:${toString config.services.bazarr.listenPort}";

            listenAddress = "127.0.0.1";
          };
        };

        scrapeConfigs = [
          {
            job_name = "exportarr-radarr";
            static_configs = [
              {
                targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.exportarr-radarr.port}" ];
              }
            ];
          }
        ];
      };

      nginx.virtualHosts."radarr.laptop.local.bhasher.com".locations."/" = {
        recommendedProxySettings = true;
        proxyPass = "http://127.0.0.1:${toString config.services.radarr.settings.server.port}";
      };
      nginx.virtualHosts."sonarr.laptop.local.bhasher.com".locations."/" = {
        recommendedProxySettings = true;
        proxyPass = "http://127.0.0.1:${toString config.services.sonarr.settings.server.port}";
      };
      nginx.virtualHosts."prowlarr.laptop.local.bhasher.com".locations."/" = {
        recommendedProxySettings = true;
        proxyPass = "http://127.0.0.1:${toString config.services.prowlarr.settings.server.port}";
      };
      nginx.virtualHosts."bazarr.laptop.local.bhasher.com".locations."/" = {
        recommendedProxySettings = true;
        proxyPass = "http://127.0.0.1:${toString config.services.bazarr.listenPort}";
      };
    };

    environment.persistence."/persistent" = {
      enable = lib.mkDefault false;
      directories = [
        "/var/lib/radarr"
        "/var/lib/sonarr"
        "/var/lib/prowlarr"
        "/var/lib/bazarr"
      ];
    };

    users.groups.media = { };
  };
}
