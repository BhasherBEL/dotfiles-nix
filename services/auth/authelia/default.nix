{
  lib,
  config,
  ...
}:
let
  cfg = config.hostServices.auth.authelia;
in
{
  imports = [
    ./snippets.nix
  ];

  options = {
    hostServices.auth.authelia = {
      enable = lib.mkEnableOption "Enable Authelia authentication service";
      hostname = lib.mkOption {
        type = lib.types.str;
        default = "idp.bhasher.com";
        description = "The hostname for Authelia.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets = {
      "services/authelia/jwtSecret" = {
        owner = config.users.users.authelia.name;
      };
      "services/authelia/sessionSecret" = {
        owner = config.users.users.authelia.name;
      };
      "services/authelia/storageEncryptionKey" = {
        owner = config.users.users.authelia.name;
      };
      "services/authelia/smtpPassword" = {
        owner = config.users.users.authelia.name;
      };
      "services/authelia/smtpUser" = {
        owner = config.users.users.authelia.name;
      };
      "services/authelia/oidcIssuerPrivateKey" = {
        owner = config.users.users.authelia.name;
      };
      "services/authelia/oidcHmacSecret" = {
        owner = config.users.users.authelia.name;
      };
    };

    services = {
      authelia.instances."idp" = {
        enable = true;
        user = "authelia";
        group = "authelia";
        secrets = {
          jwtSecretFile = "/run/secrets/services/authelia/jwtSecret";
          sessionSecretFile = "/run/secrets/services/authelia/sessionSecret";
          storageEncryptionKeyFile = "/run/secrets/services/authelia/storageEncryptionKey";
          oidcIssuerPrivateKeyFile = "/run/secrets/services/authelia/oidcIssuerPrivateKey";
          oidcHmacSecretFile = "/run/secrets/services/authelia/oidcHmacSecret";
        };
        settings = {
          theme = "dark";
          server = {
            address = "127.0.0.1:9091";
            endpoints = {
              authz = {
                auth-request = {
                  implementation = "AuthRequest";
                };
              };
              rate_limits = {
                second_factor_totp = {
                  enable = false;
                };
                second_factor_duo = {
                  enable = false;
                };
              };
            };
          };
          log = {
            level = "debug";
          };
          totp = {
            disable = false;
            issuer = "idp.bhasher.com";
            algorithm = "sha256";
            digits = 6;
            period = 30;
            skew = 1;
            secret_size = 32;
          };
          ntp = {
            disable_startup_check = true;
          };
          authentication_backend = {
            password_reset = {
              disable = false;
            };
            refresh_interval = "5m";
            ldap = {
              implementation = "lldap";
              address = "ldap://127.0.0.1:3890";
              base_dn = "dc=bhasher,dc=com";
              user = "uid=readonly,ou=people,dc=bhasher,dc=com";
              password = "{{- fileContent \"/run/secrets/services/lldap/readonly_password\" }}";
            };
          };
          access_control = {
            default_policy = "deny";
            rules = [
              {
                domain = "radarr.bhasher.com";
                policy = "one_factor";
                subject = [ "group:lldap_mediaserver" ];
              }
              {
                domain = "sonarr.bhasher.com";
                policy = "one_factor";
                subject = [ "group:lldap_mediaserver" ];
              }
              {
                domain = "jellyfin.bhasher.com";
                policy = "one_factor";
                subject = [ "group:lldap_mediaserver" ];
              }
              {
                domain = "paperless.bhasher.com";
                policy = "two_factor";
                subject = [
                  "group:lldap_family"
                  "group:lldap_admin"
                ];
              }
              {
                domain = "mealie.bhasher.com";
                policy = "one_factor";
                subject = [ "group:lldap_member" ];
                methods = [
                  "GET"
                  "HEAD"
                  "POST"
                  "PUT"
                  "DELETE"
                  "CONNECT"
                  "OPTIONS"
                  "TRACE"
                ];
              }
              {
                domain = "ldap.bhasher.com";
                policy = "two_factor";
                subject = [
                  "group:lldap_admin"
                ];
              }
              {
                domain = "*.bhasher.com";
                policy = "one_factor";
                subject = [ "group:lldap_admin" ];
              }
            ];
          };
          webauthn = {
            disable = false;
            enable_passkey_login = true;
            display_name = "Authelia";
          };
          session = {
            name = "auth_session";
            same_site = "lax";
            inactivity = "1d";
            expiration = "1w";
            remember_me = "1M";
            cookies = [
              {
                domain = "bhasher.com";
                authelia_url = "https://idp.bhasher.com";
                default_redirection_url = "https://hub.bhasher.com";
              }
            ];
            redis = {
              host = "/run/valkey/valkey.sock";
            };
          };
          regulation = {
            max_retries = 3;
            find_time = "1m";
            ban_time = "5m";
          };
          storage = {
            postgres = {
              address = "unix:///var/run/postgresql";
              database = "authelia";
              schema = "public";
              username = "authelia";
            };
          };
          notifier = {
            disable_startup_check = true;
            smtp = {
              address = "smtp://smtp.bhasher.com:587";
              sender = "no-reply@bhasher.com";
            };
          };
          password_policy = {
            standard = {
              enabled = true;
              min_length = 8;
              max_length = 0;
              require_uppercase = false;
              require_lowercase = false;
              require_number = false;
              require_special = false;
            };
          };
          telemetry = {
            metrics = {
              enabled = true;
              address = "tcp://0.0.0.0:9959";
              buffers = {
                read = 4096;
                write = 4096;
              };
              timeouts = {
                read = "6s";
                write = "6s";
                idle = "30s";
              };
            };
          };
          identity_providers = {
            oidc = {
              enforce_pkce = "public_clients_only";
              cors = {
                allowed_origins_from_client_redirect_uris = true;
                endpoints = [
                  "authorization"
                  "token"
                  "revocation"
                  "introspection"
                ];
              };
              clients = [
                {
                  client_id = "grafana";
                  client_name = "Grafana";
                  client_secret = "$argon2id$v=19$m=65536,t=3,p=4$dQfNyInvlh1Lgw3JXi7G6A$M/WaNpHJkAyaQcXIMsOTl0+gBWGPPVBoCm7NpEQfTpI";
                  public = false;
                  authorization_policy = "two_factor";
                  redirect_uris = [ "https://grafana.bhasher.com/login/generic_oauth" ];
                  consent_mode = "implicit";
                  scopes = [
                    "openid"
                    "profile"
                    "groups"
                    "email"
                  ];
                  userinfo_signed_response_alg = "none";
                }
                {
                  client_id = "matrix_synapse";
                  client_name = "Matrix Synapse";
                  client_secret = "$argon2id$v=19$m=65536,t=3,p=4$Z+6HONrjDp54s+MhXuq1cA$bjc5tMGD3gR6AaBYIDx3S2mz/UfPv6a0n1Vf3q2Ifik";
                  public = false;
                  authorization_policy = "one_factor";
                  redirect_uris = [ "https://matrix.bhasher.com/_synapse/client/oidc/callback" ];
                  consent_mode = "implicit";
                  scopes = [
                    "openid"
                    "profile"
                    "email"
                  ];
                  userinfo_signed_response_alg = "none";
                }
                {
                  client_id = "jellyfin";
                  client_name = "Jellyfn";
                  client_secret = "$argon2id$v=19$m=65536,t=3,p=4$+AqLF91LkfyZJIhjxq3lVQ$m0aSF/XYaWAU1NgRUlwMC3cB0k09Jg+HBBXa8iJWCLk";
                  public = false;
                  authorization_policy = "one_factor";
                  redirect_uris = [ "https://jellyfin.bhasher.com/sso/OID/redirect/Authelia" ];
                  consent_mode = "implicit";
                  scopes = [
                    "openid"
                    "profile"
                    "groups"
                    "email"
                  ];
                  userinfo_signed_response_alg = "none";
                }
                {
                  client_id = "miniflux";
                  client_name = "Miniflux";
                  client_secret = "$argon2id$v=19$m=65536,t=3,p=4$6CLrUJhwSMsOAryD/Fn0JA$1Lw6ECq0SSxDOQhbxM3nuHaXaEbXyVOgndGjAkTmkbc";
                  public = false;
                  authorization_policy = "one_factor";
                  redirect_uris = [ "https://miniflux.bhasher.com/oauth2/oidc/callback" ];
                  consent_mode = "implicit";
                  scopes = [
                    "openid"
                    "profile"
                    "groups"
                    "email"
                  ];
                  userinfo_signed_response_alg = "none";
                }
                {
                  client_id = "mealie";
                  client_name = "Mealie";
                  client_secret = "$argon2id$v=19$m=65536,t=3,p=4$H+PWfdgUPIh0DOyTF6Wjxw$3OT1G0i1BzOOmHKNc8gjuxWeCEs7SWYh1X9xd7/3SNU";
                  public = false;
                  authorization_policy = "one_factor";
                  redirect_uris = [ "https://recipes.bhasher.com/login" ];
                  consent_mode = "implicit";
                  scopes = [
                    "openid"
                    "profile"
                    "email"
                    "groups"
                  ];
                  userinfo_signed_response_alg = "none";
                }
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
                {
                  client_id = "openwebui";
                  client_name = "OpenWebUI";
                  client_secret = "$argon2id$v=19$m=65536,t=3,p=4$8zijuZcGfh2m5RjqL42dLg$ZEiQJz3tRNSZlFpRQaKkxtaieCV7u57QGA3vo9Uu8jA";
                  public = false;
                  authorization_policy = "one_factor";
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
                {
                  client_id = "mas";
                  client_name = "Matrix Authentication Service";
                  client_secret = "$argon2id$v=19$m=65536,t=3,p=4$4oeGB2RcziBGMvSnVJBmAw$B/6yUd4XH6mqW3QXISNdg1F3HQwzaoA6czhWsNvNWBY";
                  public = false;
                  redirect_uris = [ "https://mas.bhasher.com/upstream/callback/01JJZD84RP70N2Q5YSTG2H6SPV" ];
                  consent_mode = "implicit";
                  scopes = [
                    "openid"
                    "groups"
                    "profile"
                    "email"
                  ];
                  response_types = [ "code" ];
                }
                {
                  client_id = "audiobookshelf";
                  client_name = "AudioBookShelf";
                  client_secret = "$argon2id$v=19$m=65536,t=3,p=4$LaDUN+jpADJ5A8cH1MCeXg$bfWOAiHbxkhPsJ1+ks2kdKwi8frSuCMm3HXX+Qu7KXc";
                  public = false;
                  redirect_uris = [
                    "https://audio.bhasher.com/auth/openid/callback"
                    "https://audio.bhasher.com/auth/openid/mobile-redirect"
                  ];
                  authorization_policy = "one_factor";
                  consent_mode = "implicit";
                  scopes = [
                    "openid"
                    "groups"
                    "profile"
                    "email"
                  ];
                }
              ];
            };
          };
        };
      };
      nginx.virtualHosts."${cfg.hostname}" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          recommendedProxySettings = true;
          proxyPass = "http://127.0.0.1:9091";
        };
      };
    };

    hostServices = {
      storage = {
        valkey.enable = true;
        postgresql.access = [ "authelia" ];
      };
      auth.lldap.enable = true;
    };

    users = {
      users.authelia = {
        isSystemUser = true;
        group = "authelia";
        extraGroups = [
          "valkey"
          "postgresql"
        ];
      };
      groups.authelia = { };
    };

    environment.persistence."/persistent" = {
      enable = lib.mkDefault false;
      directories = [
        "/var/lib/authelia-idp"
      ];
    };
  };
}
