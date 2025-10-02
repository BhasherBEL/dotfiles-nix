{
  lib,
  config,
  ...
}:
let
  cfg = config.hostServices.firefly-iii;
in
{
  options.hostServices.firefly-iii = {
    enable = lib.mkEnableOption "Enable Firefly III";
    hostname = lib.mkOption {
      type = lib.types.str;
      default = "firefly.bhasher.com";
      description = "The hostname for Firefly III";
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets = {
      "services/fireflyiii/app_key" = {
        owner = config.services.firefly-iii.user;
        group = config.services.firefly-iii.group;
      };
    };

    services = {
      firefly-iii = {
        enable = true;
        dataDir = "/var/lib/firefly-iii";
        virtualHost = cfg.hostname;
        user = "firefly-iii";
        group = "nginx";
        enableNginx = false;
        settings = {
          APP_ENV = "production";
          APP_KEY_FILE = config.sops.secrets."services/fireflyiii/app_key".path;
          DB_CONNECTION = "pgsql";
          DB_HOST = "/var/run/postgresql";
          APP_URL = "https://${cfg.hostname}";
          AUTHENTICATION_GUARD = "remote_user_guard";
          AUTHENTICATION_GUARD_HEADER = "Remote-User";
          TRUSTED_PROXIES = "**";
          TZ = "Europe/Paris";
        };
      };
      nginx.virtualHosts."${cfg.hostname}" = {
        forceSSL = true;
        enableACME = true;
        root = "${config.services.firefly-iii.package}/public";
        locations = {
          "/" = {
            tryFiles = "$uri $uri/ /index.php?$query_string";
            index = "index.php";
            extraConfig = ''
              sendfile off;
              include ${config.hostServices.auth.authelia.snippets.request};
              add_header X-Debug-Remote-User $user;
              add_header X-Debug-Remote-Email $email;
              location ~* \.php(?:$|/) {
              	include ${config.hostServices.auth.authelia.snippets.request};
              	include ${config.services.nginx.package}/conf/fastcgi_params ;
              	fastcgi_param HTTP_REMOTE_USER $user;
              	fastcgi_param HTTP_REMOTE_EMAIL $email;
              	fastcgi_param HTTP_REMOTE_GROUPS $groups;
              	fastcgi_param HTTP_REMOTE_NAME $name;
              	fastcgi_param SCRIPT_FILENAME $request_filename;
              	fastcgi_param modHeadersAvailable true;
              	fastcgi_pass unix:${config.services.phpfpm.pools.firefly-iii.socket};
              }
            '';
          };

          "/internal/authelia/authz" = {
            recommendedProxySettings = false;
            extraConfig = "include ${config.hostServices.auth.authelia.snippets.location};";
          };
          "^~ /api/" = {
            tryFiles = "$uri $uri/ @api";
            index = "index.php";
            extraConfig = ''
              sendfile off;
            '';
          };
          "@api" = {
            extraConfig = ''
              include ${config.services.nginx.package}/conf/fastcgi_params;
              fastcgi_param SCRIPT_FILENAME ${config.services.firefly-iii.package}/public/index.php;
              fastcgi_param modHeadersAvailable true;
              fastcgi_pass unix:${config.services.phpfpm.pools.firefly-iii.socket};
            '';
          };
        };
      };
    };

    hostServices = {
      storage.postgresql.access = [ "firefly-iii" ];
    };

    environment.persistence."/persistent" = {
      enable = lib.mkDefault false;
      directories = [
        "/var/lib/private/firefly-iii"
      ];
    };
  };
}
