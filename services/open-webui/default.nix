{ lib, config, ... }:
let
  cfg = config.hostServices.open-webui;
in
{
  options = {
    hostServices.open-webui = {
      enable = lib.mkEnableOption "Enable open-webui";
      hostname = lib.mkOption {
        type = lib.types.str;
        default = "ai.bhasher.com";
        description = "The hostname for open-webui";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets = {
      "services/open-webui/env" = {
        owner = config.services.paperless.user;
      };
    };
    services = {
      open-webui = {
        enable = true;
        stateDir = "/var/lib/open-webui";
        environmentFile = config.sops.secrets."services/open-webui/env".path;
        port = 4860;
        environment = {
          TZ = "Europe/Paris";
          WEBUI_NAME = "Bhasher's AI";
          WEBUI_URL = "https://ai.bhasher.com";
          JWT_EXPIRES_IN = "1w";
          # OLLAMA_BASE_URL = "http://ollama:11434";
          ENABLE_OAUTH_SIGNUP = "true";
          ENABLE_LOGIN_FORM = "false";
          ENABLE_SIGNUP = "false";
          DEFAULT_USER_ROLE = "user";
          OAUTH_CLIENT_ID = "openwebui";
          OPENID_PROVIDER_URL = "https://idp.bhasher.com/.well-known/openid-configuration";
          OAUTH_PROVIDER_NAME = "Authelia";
          OAUTH_ADMIN_ROLES = "admin";
          OAUTH_ALLOWED_ROLES = "ai,admin";
          DEFAULT_MODELS = "mistral";
          TASK_MODEL = "mistral";
          RAG_WEB_SEARCH_ENGINE = "duckduckgo";
          ENABLE_RAG_WEB_SEARCH = "true";
        };
      };
      authelia.instances."idp".settings.identity_providers.oidc.clients = [
        {
          client_id = "openwebui";
          client_name = "OpenWebUI";
          client_secret = "$argon2id$v=19$m=65536,t=3,p=4$89vlNDQhAJ/YazYB9x2udg$EQHzOPcIxigZAzALQPYiPfPhqghdW4rCs9YIZL/DLvw";
          public = false;
          authorization_policy = "two_factor";
          redirect_uris = [ "https://ai.bhasher.com/oauth/oidc/callback" ];
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
      nginx.virtualHosts."${cfg.hostname}" = {
        forceSSL = true;
        enableACME = true;
        locations = {
          "/" = {
            proxyPass = "http://127.0.0.1:${toString config.services.open-webui.port}";
            recommendedProxySettings = true;
            proxyWebsockets = true;
            extraConfig = ''
              proxy_buffering off;
            '';
          };
        };
      };
    };

    environment.persistence."/persistent" = {
      enable = lib.mkDefault false;
      directories = [
        "/var/lib/private/open-webui"
      ];
    };
  };
}
