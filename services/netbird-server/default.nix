{ lib, config, ... }:
let
  cfg = config.hostServices.netbird-server;
in
{
  options = {
    hostServices.netbird-server = {
      enable = lib.mkEnableOption "Enable netbird-server";
      hostname = lib.mkOption {
        type = lib.types.str;
        default = "vpn.bhasher.com";
        description = "The hostname for netbird public server";
      };
      management = {
        hostname = lib.mkOption {
          type = lib.types.str;
          default = "netbird.bhasher.com";
          description = "The hostname for the netbird management server";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets = {
      "services/netbird_server/auth_secret" = {
        owner = config.services.paperless.user;
      };
      "services/netbird_server/encryption_key" = {
        owner = config.services.paperless.user;
      };
    };
    services = {
      netbird.server = {
        enable = true;
        domain = cfg.hostname;
        enableNginx = false;
        management = {
          domain = cfg.management.hostname;
          oidcConfigEndpoint = "https://${config.hostServices.authelia.hostname}/.well-known/openid-configuration";
          settings = {
            server = {
              listenAddres = ":8011";
              exposedAddress = "https://${cfg.hostname}:443";
              stunPorts = [
                3478
              ];
              metricsPort = 9090;
              healthcheckAddress = ":9000";
              logLevel = "info";
              logFile = "console";

              authSecret = config.sops.secrets."services/netbird_server/auth_secret".path;
              dataDir = "/var/lib/netbird-mgmt";

              auth = {
                issuer = "https://${cfg.hostname}/oauth2";
                signKeyRefreshEnabled = true;
                dashboardRedirectURIs = [
                  "https://${cfg.management.hostname}/nb-auth"
                  "https://${cfg.management.hostname}/nb-silent-auth"
                ];
                cliRedirectURIs = [
                  "http://localhost:53000/"
                ];
              };
              reverseProxy = {
                trustedHTTPProxies = [
                  "172.20.0.0/16"
                ];
              };
              store = {
                engine = "postgres";
                encryptionKey = config.sops.secrets."services/netbird_server/encryption_key".path;
                dsn = "user=netbird_store host=/var/run/postgresql dbname=netbird_store";
              };
              activityStore = {
                engine = "postgres";
                dsn = "user=netbird_activity host=/var/run/postgresql dbname=netbird_activity";
              };
              authStore = {
                engine = "postgres";
                dsn = "user=netbird_auth host=/var/run/postgresql dbname=netbird_auth";
              };
              HttpConfig = {
                AuthAudience = "netbird";
                AuthIssuer = "https://${config.hostServices.authelia.hostname}";
                AuthKeysLocation = "https://${config.hostServices.authelia.hostname}/openid-connect/certs";
                IdpSignKeyRefreshEnabled = false;
              };
            };
          };
        };
      };
      authelia.instances."idp".settings.identity_providers.oidc.clients = [
        {
          client_id = "netbird";
          client_name = "Netbird";
          client_secret = "$argon2id$v=19$m=65536,t=3,p=4$r2u1XcVH/hptgFfkg1H97A$TQh/rUxgBcSZbaIThdBem/s0GBn/E/OS34whixG7BPw";
          public = false;
          authorization_policy = "two_factor";
          redirect_uris = [
            "https://${cfg.hostname}/oauth2/callback"
            "https://${cfg.management.hostname}/oauth2/callback"
            "http://localhost:53000"
          ];
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
      nginx.virtualHosts = {
        "${cfg.hostname}" = {
          forceSSL = true;
          enableACME = true;
          locations = {
            "/api".proxyPass = "http://localhost:8011";

            "/management.ManagementService/".extraConfig = ''
              # This is necessary so that grpc connections do not get closed early
              # see https://stackoverflow.com/a/67805465
              client_body_timeout 1d;

              grpc_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

              grpc_pass grpc://localhost:8011;
              grpc_read_timeout 1d;
              grpc_send_timeout 1d;
              grpc_socket_keepalive on;
            '';
          };
        };
        "${cfg.management.hostname}" = {
          forceSSL = true;
          enableACME = true;
          locations = {
            "/" = {
              proxyPass = "http://127.0.0.1:8011";
              recommendedProxySettings = true;
              proxyWebsockets = true;
            };
          };
        };
      };
    };

    hostServices.storage.postgresql.access = [
      "netbird_store"
      "netbird_activity"
      "netbird_auth"
    ];

    environment.persistence."/persistent" = {
      enable = lib.mkDefault false;
      directories = [
        "/var/lib/netbird-mgmt"
      ];
    };
  };
}
