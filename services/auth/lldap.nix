{
  lib,
  config,
  ...
}:
let
  cfg = config.hostServices.auth.lldap;
in
{
  options = {
    hostServices.auth.lldap = {
      enable = lib.mkEnableOption "Enable lldap service";
      hostname = lib.mkOption {
        type = lib.types.str;
        default = "ldap.bhasher.com";
        description = "The hostname for LLDAP.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets = {
      "services/lldap/admin_password" = {
        mode = "0444";
      };
      "services/lldap/readonly_password" = {
        mode = "0444";
      };
    };

    services = {
      lldap = {
        enable = true;
        settings = {
          ldap_host = "127.0.0.1";
          ldap_port = 3890;
          database_url = "sqlite:////var/lib/lldap/lldap.db?mode=rwc";
          # ldap_user_pass_file = "/run/credentials/lldap.service/admin_password";
          ldap_user_pass_file = "/run/secrets/services/lldap/admin_password";
          ldap_user_dn = "admin";
          ldap_base_dn = "dc=bhasher,dc=com";
          force_ldap_user_pass_reset = "always";
          http_url = "https://${cfg.hostname}";
          http_host = "127.0.0.1";
          http_port = 17170;
        };
      };
      nginx.virtualHosts."${cfg.hostname}" = {
        forceSSL = true;
        enableACME = true;
        locations = {
          "/" = {
            recommendedProxySettings = true;
            proxyPass = "http://127.0.0.1:17170";
            extraConfig = "include ${config.hostServices.auth.authelia.snippets.request};";
          };
          "/internal/authelia/authz" = {
            recommendedProxySettings = false;
            extraConfig = "include ${config.hostServices.auth.authelia.snippets.location};";
          };
        };
      };
    };

    # systemd.services.lldap.serviceConfig.LoadCredential = "admin_password:${
    #   config.sops.secrets."services/lldap/admin_password".path
    # }";

    environment.persistence."/persistent" = {
      enable = lib.mkDefault false;
      directories = [
        "/var/lib/private/lldap/"
      ];
    };

    hostServices.restic.paths = [ "/persistent/var/lib/private/lldap" ];
  };
}
