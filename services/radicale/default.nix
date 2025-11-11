{ lib, config, ... }:
let
  cfg = config.hostServices.radicale;
in
{
  options = {
    hostServices.radicale = {
      enable = lib.mkEnableOption "Enable radicale";
      hostname = lib.mkOption {
        type = lib.types.str;
        default = "radicale.bhasher.com";
        description = "The hostname for radicale";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets = {
      "services/lldap/readonly_password" = {
        mode = "0444";
      };
    };
    services = {
      radicale = {
        enable = true;
        settings = {
          auth = {
            type = "ldap";
            ldap_uri = "ldap://${config.services.lldap.settings.ldap_host}:${toString config.services.lldap.settings.ldap_port}";
            ldap_base = config.services.lldap.settings.ldap_base_dn;
            ldap_reader_dn = "uid=readonly,ou=people,${config.services.lldap.settings.ldap_base_dn}";
            ldap_secret_file = "/run/secrets/services/lldap/readonly_password";
            ldap_filter = "(&(objectClass=person)(uid={0})(memberOf=cn=calendar,ou=groups,${config.services.lldap.settings.ldap_base_dn}))";
            ldap_user_attribute = "displayname";
            ldap_security = "none";
            ldap_groups_attribute = "memberOf";
            lc_username = true;
          };
          storage = {
            filesystem_folder = "/var/lib/radicale/collections/";
          };
        };
        rights = {
          root = {
            user = ".+";
            collection = "";
            permissions = "R";
          };
          principal = {
            user = ".+";
            collection = "{user}";
            permissions = "RW";
          };
          calendars = {
            user = ".+";
            collection = "{user}/[^/]+";
            permissions = "rw";
          };
          groups = {
            user = ".+";
            collection = "GROUPS/[^/]+";
            permissions = "rw";
          };
        };
      };
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
            proxyPass = "http://127.0.0.1:5232";
            recommendedProxySettings = true;
          };
          "/.well-known/caldav" = {
            return = "301 https://${cfg.hostname}";
          };
          "/.well-known/carddav" = {
            return = "301 https://${cfg.hostname}";
          };
        };
      };
    };

    environment.persistence."/persistent" = {
      enable = lib.mkDefault false;
      directories = [
        {
          directory = "/var/lib/radicale";
          user = config.systemd.services.radicale.serviceConfig.User;
          group = config.systemd.services.radicale.serviceConfig.Group;
        }
      ];
    };
  };
}
