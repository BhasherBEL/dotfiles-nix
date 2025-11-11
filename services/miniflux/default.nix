{ lib, config, ... }:
let
  cfg = config.hostServices.miniflux;
in
{
  options = {
    hostServices.miniflux = {
      enable = lib.mkEnableOption "Enable miniflux";
      hostname = lib.mkOption {
        type = lib.types.str;
        default = "miniflux.bhasher.com";
        description = "The hostname for miniflux";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets = {
      "services/miniflux/oauth2_client_secret" = {
        mode = "0444";
      };
    };

    services = {
      miniflux = {
        enable = true;
        createDatabaseLocally = false;
        config = {
          BASE_URL = "https://miniflux.bhasher.com";
          DATABASE_URL = "user=miniflux host=/var/run/postgresql dbname=miniflux";
          RUN_MIGRATIONS = 1;
          OAUTH2_PROVIDER = "oidc";
          OAUTH2_CLIENT_ID = "miniflux";
          OAUTH2_CLIENT_SECRET_FILE = config.sops.secrets."services/miniflux/oauth2_client_secret".path;
          OAUTH2_REDIRECT_URL = "https://miniflux.bhasher.com/oauth2/oidc/callback";
          OAUTH2_OIDC_DISCOVERY_ENDPOINT = "https://idp.bhasher.com";
          OAUTH2_USER_CREATION = 1;
          CREATE_ADMIN = 0;
        };
      };
      nginx.virtualHosts."${cfg.hostname}" = {
        forceSSL = true;
        enableACME = true;
        locations = {
          "/" = {
            proxyPass = "http://127.0.0.1:8080";
            recommendedProxySettings = true;
          };
        };
      };
    };

    systemd.services.miniflux.after = [ "postgresql.service" ];

    hostServices = {
      storage.postgresql.access = [ "miniflux" ];
    };
    #
    # users = {
    #   users.miniflux = {
    #     isSystemUser = true;
    #     group = "miniflux";
    #     extraGroups = [
    #       "postgresql"
    #     ];
    #   };
    #   groups.miniflux = { };
    # };

    environment.persistence."/persistent" = {
      enable = lib.mkDefault false;
      directories = [
        "/var/lib/private/miniflux"
      ];
    };

    hostServices.restic.paths = [ "/persistent/var/lib/private/miniflux" ];
  };
}
