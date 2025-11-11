{ lib, config, ... }:
let
  settings = config.services.grafana.settings;
in
{
  imports = [
    ./../nginx.nix
  ];

  options = {
    hostServices.monitoring.grafana.enable = lib.mkEnableOption "Enable grafana service";
  };

  config = lib.mkIf config.hostServices.monitoring.grafana.enable {
    sops.secrets = {
      "services/grafana/client_secret" = {
        owner = config.users.users.grafana.name;
      };
    };

    services = {
      grafana = {
        enable = true;
        settings = {
          server = rec {
            domain = "grafana.bhasher.com";
            root_url = "https://${domain}";
            # enforce_domain = true;
            enable_gzip = true;
          };
          auth = {
            disable_signout_menu = false;
            oauth_allow_insecure_email_lookup = true;
          };
          "auth.generic_oauth" = {
            enabled = true;
            icon = "signin";
            name = "Authelia";
            client_id = "grafana";
            client_secret = "$__file{/run/secrets/services/grafana/client_secret}";
            scopes = [
              "openid"
              "email"
              "profile"
              "groups"
            ];
            auth_url = "https://idp.bhasher.com/api/oidc/authorization";
            token_url = "https://idp.bhasher.com/api/oidc/token";
            api_url = "https://idp.bhasher.com/api/oidc/userinfo";
            login_attribute_path = "preferred_username";
            groups_attribute_path = "groups";
            name_attribute_path = "name";
            email_attribute_path = "email";
            role_attribute_path = "contains(groups[*], 'admin') ? 'Admin' : 'Viewer'";
            use_pkce = false;
            allow_assign_grafana_admin = true;
          };
        };
        provision = {
          enable = true;
          datasources.settings = {
            apiVersion = 1;
            datasources = [
              {
                name = "Prometheus";
                type = "prometheus";
                url = "http://localhost:${toString config.services.prometheus.port}";
              }
            ];
          };
        };
      };

      nginx.virtualHosts."${settings.server.domain}" = {
        # enableACME = true;
        # forceSSL = true;
        locations."/" = {
          recommendedProxySettings = true;
          proxyPass = "http://${toString settings.server.http_addr}:${toString settings.server.http_port}";
        };
      };
    };

    environment.persistence."/persistent" = {
      enable = lib.mkDefault false;
      directories = [
        "/var/lib/grafana"
      ];
    };

    hostServices.restic.paths = [ "/persistent/var/lib/grafana" ];
  };
}
