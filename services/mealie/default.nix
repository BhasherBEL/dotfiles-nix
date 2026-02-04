{ lib, config, ... }:
let
  cfg = config.hostServices.mealie;
in
{
  options = {
    hostServices.mealie = {
      enable = lib.mkEnableOption "Enable mealie";
      hostname = lib.mkOption {
        type = lib.types.str;
        default = "recipes.bhasher.com";
        description = "The hostname for mealie";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets = {
      "services/mealie/env" = { };
    };
    services = {
      mealie = {
        enable = true;
        settings = {
          TZ = "Europe/Paris";
          BASE_URL = "https://recipes.bhasher.com";
          OIDC_AUTH_ENABLED = "true";
          OIDC_SIGNUP_ENABLE = "true";
          OIDC_REMEMBER_ME = "true";
          OIDC_AUTO_REDIRECT = "false";
          OIDC_CONFIGURATION_URL = "https://idp.bhasher.com/.well-known/openid-configuration";
          OIDC_CLIENT_ID = "mealie";
          OIDC_PROVIDER_NAME = "Authelia";
          OIDC_USER_GROUP = "family";
          OIDC_ADMIN_GROUP = "lldap_admin";
          DB_ENGINE = "postgres";
          POSTGRES_URL_OVERRIDE = "postgresql://mealie:@/mealie?host=/var/run/postgresql";
        };
        credentialsFile = "${config.sops.secrets."services/mealie/env".path}";
      };
      authelia.instances."idp".settings.identity_providers.oidc.clients = [
        {
          client_id = "mealie";
          client_name = "Mealie";
          client_secret = "$argon2id$v=19$m=65536,t=3,p=4$H+PWfdgUPIh0DOyTF6Wjxw$3OT1G0i1BzOOmHKNc8gjuxWeCEs7SWYh1X9xd7/3SNU";
          public = false;
          authorization_policy = "one_factor";
          redirect_uris = [ "https://recipes.bhasher.com/login" ];
          consent_mode = "implicit";
          require_pkce = true;
          pkce_challenge_method = "S256";
          scopes = [
            "openid"
            "profile"
            "email"
            "groups"
          ];
          response_types = [
            "code"
          ];
          grant_types = [
            "authorization_code"
          ];
          userinfo_signed_response_alg = "none";
          access_token_signed_response_alg = "none";
          token_endpoint_auth_method = "client_secret_basic";
        }
      ];
      nginx.virtualHosts."${cfg.hostname}" = {
        forceSSL = true;
        enableACME = true;
        listen = [
          {
            addr = "0.0.0.0";
            port = 443;
            ssl = true;
          }
          {
            addr = "0.0.0.0";
            port = 444;
            ssl = true;
          }
        ];
        locations = {
          "/" = {
            proxyPass = "http://127.0.0.1:${toString config.services.mealie.port}";
            recommendedProxySettings = true;
          };
        };
      };
    };

    systemd.services.mealie = {
      after = [ "postgresql.service" ];
    };

    hostServices = {
      storage.postgresql.access = [ "mealie" ];
    };

    environment.persistence."/persistent" = {
      enable = lib.mkDefault false;
      directories = [
        "/var/lib/private/mealie"
      ];
    };

    hostServices.restic.paths = [ "/persistent/var/lib/private/mealie" ];
  };
}
