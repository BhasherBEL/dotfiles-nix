{ lib, config, ... }:
let
  cfg = config.hostServices.paperless;
in
{
  options = {
    hostServices.paperless = {
      enable = lib.mkEnableOption "Enable paperless";
      hostname = lib.mkOption {
        type = lib.types.str;
        default = "paperless.bhasher.com";
        description = "The hostname for paperless";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets = {
      "services/paperless/env" = {
        owner = config.services.paperless.user;
      };
    };
    services = {
      authelia.instances."idp".settings.identity_providers.oidc.clients = [
        {
          client_id = "paperless-ngx";
          client_name = "Paperless NGX";
          client_secret = "$argon2id$v=19$m=65536,t=3,p=4$kujFSqxNtfP0neWECtdwoQ$bmEqT9v47rXXKEDtLWiZO10VH7yGgNPRjflM/UWwCXg";
          public = false;
          authorization_policy = "two_factor";
          redirect_uris = [ "https://paperless.bhasher.com/accounts/oidc/authelia/login/callback/" ];
          consent_mode = "implicit";
          scopes = [
            "openid"
            "profile"
            "email"
            "groups"
          ];
          userinfo_signed_response_alg = "none";
        }
      ];
      paperless = {
        enable = true;
        domain = cfg.hostname;
        dataDir = "/var/lib/paperless/data";
        mediaDir = "/var/lib/paperless/media";
        consumptionDir = "/srv/syncthing/SyncDocuments/consume";
        exporter.directory = "/var/lib/paperless/export";
        consumptionDirIsPublic = true;
        environmentFile = config.sops.secrets."services/paperless/env".path;
        settings = {
          PAPERLESS_CONSUMER_IGNORE_PATTERN = [
            ".DS_STORE/*"
            "desktop.ini"
          ];
          PAPERLESS_OCR_LANGUAGE = "fra+eng";
          PAPERLESS_OCR_USER_ARGS = {
            optimize = 1;
            pdfa_image_compression = "lossless";
          };
          PAPERLESS_DISABLE_REGULAR_LOGIN = true;
          PAPERLESS_APPS = "allauth.socialaccount.providers.openid_connect";
          PAPERLESS_TASK_WORKERS = 4;
          PAPERLESS_USE_X_FORWARD_HOST = true;
          PAPERLESS_USE_X_FORWARD_PORT = true;
          PAPERLESS_PROXY_SSL_HEADER = [
            "HTTP_X_FORWARDED_PROTO"
            "https"
          ];
          PAPERLESS_TIME_ZONE = "Europe/Paris";
          PAPERLESS_DBENGINE = "postgresql";
          PAPERLESS_DBHOST = "/var/run/postgresql";
          PAPERLESS_DBNAME = "paperless";
          PAPERLESS_DBUSER = "paperless";
          PAPERLESS_SECRET_KEY = "fbgdioJFSighrigr51sd5gdsf4gEGR4f4g4r";
          PAPERLESS_SOCIALACCOUNT_PROVIDERS = "{\"openid_connect\": {\"APPS\": [{\"provider_id\": \"authelia\",\"name\": \"Authelia\",\"client_id\": \"paperless-ngx\",\"secret\": \"CbcDHFVKaoS2B5DbcmuRN9fIkfY8AAX5At0i0wwHeLiDPzt0izD54AS9FUHMa9C0borpo4x3\",\"settings\": { \"server_url\": \"https://idp.bhasher.com\"}}]}}";
          PAPERLESS_REDIS = "unix://${config.services.redis.servers."".unixSocket}";
        };
      };
      nginx.virtualHosts."${cfg.hostname}" = {
        forceSSL = true;
        enableACME = true;
        locations = {
          "/" = {
            proxyPass = "http://127.0.0.1:${toString config.services.paperless.port}";
            recommendedProxySettings = true;
          };
          "/static/" = {
            root = config.services.paperless.package;
            extraConfig = ''
              rewrite ^/(.*)$ /lib/paperless-ngx/$1 break;
            '';
          };
          "/ws/status" = {
            proxyPass = "http://127.0.0.1:${toString config.services.paperless.port}";
            proxyWebsockets = true;
          };
        };
      };
    };

    # users = {
    #   users.paperless = {
    #     isSystemUser = true;
    #     group = "paperless";
    #     extraGroups = [
    #       "postgresql"
    #     ];
    #   };
    #   groups.paperless = { };
    # };

    systemd.services = {
      miniflux.after = [ "postgresql.service" ];
      paperless-web.serviceConfig.SupplementaryGroups = [ config.services.redis.servers."".group ];
      paperless-scheduler.serviceConfig.SupplementaryGroups = [ config.services.redis.servers."".group ];
      paperless-consumer.serviceConfig.SupplementaryGroups = [ config.services.redis.servers."".group ];
      paperless-task-queue.serviceConfig.SupplementaryGroups = [ config.services.redis.servers."".group ];
    };

    hostServices = {
      storage.postgresql.access = [ "paperless" ];
    };

    environment.persistence."/persistent" = {
      enable = lib.mkDefault false;
      directories = [
        {
          directory = "/var/lib/paperless";
          user = config.services.paperless.user;
        }
      ];
    };
  };
}
