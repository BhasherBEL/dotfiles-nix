{ lib, config, ... }:
{
  options = {
    hostServices.mediaserver.servarr.enable = lib.mkEnableOption "Enable Servarr";
    hostServices.mediaserver.analytics = lib.mkEnableOption "Enable analytics";
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
      };
      bazarr = {
        enable = true;
        dataDir = "/var/lib/bazarr";
        group = "media";
      };
      flaresolverr.enable = true;

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

      nginx.virtualHosts = {
        "radarr.bhasher.com" = {
          forceSSL = true;
          enableACME = true;
          locations = {
            "/" = {
              recommendedProxySettings = true;
              proxyPass = "http://127.0.0.1:${toString config.services.radarr.settings.server.port}";
              extraConfig = "include ${config.hostServices.auth.authelia.snippets.request};";
            };
            "/internal/authelia/authz" = {
              recommendedProxySettings = false;
              extraConfig = "include ${config.hostServices.auth.authelia.snippets.location};";
            };
          };
        };
        "sonarr.bhasher.com" = {
          forceSSL = true;
          enableACME = true;
          locations = {
            "/" = {
              recommendedProxySettings = true;
              proxyPass = "http://127.0.0.1:${toString config.services.sonarr.settings.server.port}";
              extraConfig = "include ${config.hostServices.auth.authelia.snippets.request};";
            };
            "/internal/authelia/authz" = {
              recommendedProxySettings = false;
              extraConfig = "include ${config.hostServices.auth.authelia.snippets.location};";
            };
          };
        };
        "prowlarr.bhasher.com" = {
          forceSSL = true;
          enableACME = true;
          locations = {
            "/" = {
              recommendedProxySettings = true;
              proxyPass = "http://127.0.0.1:${toString config.services.prowlarr.settings.server.port}";
              extraConfig = "include ${config.hostServices.auth.authelia.snippets.request};";
            };
            "/internal/authelia/authz" = {
              recommendedProxySettings = false;
              extraConfig = "include ${config.hostServices.auth.authelia.snippets.location};";
            };
          };
        };
        "bazarr.bhasher.com" = {
          forceSSL = true;
          enableACME = true;
          locations = {
            "/" = {
              recommendedProxySettings = true;
              proxyPass = "http://127.0.0.1:${toString config.services.bazarr.listenPort}";
              extraConfig = "include ${config.hostServices.auth.authelia.snippets.request};";
            };
            "/internal/authelia/authz" = {
              recommendedProxySettings = false;
              extraConfig = "include ${config.hostServices.auth.authelia.snippets.location};";
            };
          };
        };
        "flaresolverr.bhasher.com" = {
          forceSSL = true;
          enableACME = true;
          locations = {
            "/" = {
              recommendedProxySettings = true;
              proxyPass = "http://127.0.0.1:${toString config.services.flaresolverr.port}";
              extraConfig = "include ${config.hostServices.auth.authelia.snippets.request};";
            };
            "/internal/authelia/authz" = {
              recommendedProxySettings = false;
              extraConfig = "include ${config.hostServices.auth.authelia.snippets.location};";
            };
          };
        };
      };
    };

    environment.persistence."/persistent" = {
      enable = lib.mkDefault false;
      directories = [
        {
          directory = "/var/lib/radarr";
          user = config.services.radarr.user;
          group = config.services.radarr.group;
        }
        {
          directory = "/var/lib/sonarr";
          user = config.services.sonarr.user;
          group = config.services.sonarr.group;
        }
        {
          directory = "/var/lib/private/prowlarr";
        }
        {
          directory = "/var/lib/bazarr";
          user = config.services.bazarr.user;
          group = config.services.bazarr.group;
        }
      ];
    };

    users.groups.media = { };
  };
}
