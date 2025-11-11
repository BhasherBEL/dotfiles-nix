{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.hostServices.auth.openldap;
  gh_repo_docker = "https://github.com/osixia/docker-openldap/blob/635034a75878773f8576d646422cf26e43741fab/image/service/slapd/assets/config/bootstrap";
in
{
  options = {
    hostServices.auth.openldap = {
      enable = lib.mkEnableOption "Enable openldap service";
      hostname = lib.mkOption {
        type = lib.types.str;
        default = "ldap.bhasher.com";
        description = "The hostname for the LDAP server.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets = {
      "services/openldap/admin_password" = {
        owner = config.users.users.openldap.name;
      };
    };

    services.openldap = {
      enable = true;
      # urlList = [ "ldaps:///" ];
      urlList = [
        "ldap:///"
        "ldapi:///"
      ];
      settings = {
        attrs = {
          olcLogLevel = "conns config";

          # olcTLSCACertificateFile = "/var/lib/acme/${cfg.hostname}/full.pem";
          # olcTLSCertificateFile = "/var/lib/acme/${cfg.hostname}/cert.pem";
          # olcTLSCertificateKeyFile = "/var/lib/acme/${cfg.hostname}/key.pem";
          # olcTLSCipherSuite = "HIGH:MEDIUM:+3DES:+RC4:+aNULL";
          # olcTLSCRLCheck = "none";
          # olcTLSVerifyClient = "never";
          # olcTLSProtocolMin = "3.2";
        };

        children = {
          "cn=schema".includes = [
            "${pkgs.openldap}/etc/schema/core.ldif"
            "${pkgs.openldap}/etc/schema/cosine.ldif"
            "${pkgs.openldap}/etc/schema/inetorgperson.ldif"
            # Use rfc2307bis
            # (pkgs.fetchurl {
            #   url = "${gh_repo_docker}/schema/rfc2307bis.ldif";
            #   sha256 = "sha256-olvhgzbYMy0qAMqQNJZCdFKeYqiblBX2yM1K/gaRDJY=";
            # })
          ];

          "olcDatabase={1}mdb" = {
            attrs = {
              objectClass = [
                "olcDatabaseConfig"
                "olcMdbConfig"
              ];

              olcDatabase = "{1}mdb";
              olcDbDirectory = "/var/lib/openldap/data";

              olcSuffix = "dc=bhasher,dc=com";

              olcRootDN = "cn=admin,dc=bhasher,dc=com";
              olcRootPW.path = "/run/secrets/services/openldap/admin_password";

              olcAccess = [
                ''
                  {0}to attrs=userPassword
                                by self write
                                by anonymous auth
                                by * none''
                ''
                  {1}to *
                                by * read''
              ];
            };

            children = {
              "olcOverlay={4}ppolicy".attrs = {
                objectClass = [
                  "olcOverlayConfig"
                  "olcPPolicyConfig"
                  "top"
                ];
                olcOverlay = "{4}ppolicy";
                olcPPolicyHashCleartext = "TRUE";
              };

              "olcOverlay={0}memberof".attrs = {
                objectClass = [
                  "olcOverlayConfig"
                  "olcMemberOf"
                ];
                olcOverlay = "{0}memberof";
                olcMemberOfRefInt = "TRUE";
                olcMemberOfDangling = "ignore";
                olcMemberOfGroupOC = "groupOfNames";
                olcMemberOfMemberAD = "uniqueMember";
                olcMemberOfMemberOfAD = "memberOf";
              };

              "olcOverlay={1}refint".attrs = {
                objectClass = [
                  "olcOverlayConfig"
                  "olcRefintConfig"
                ];
                olcOverlay = "{1}refint";
                olcRefintAttribute = "memberof member manager owner uniqueMember";
              };
            };
          };
        };
      };
    };

    # systemd.services.openldap = {
    #   wants = [ "acme-${cfg.hostname}.service" ];
    #   after = [ "acme-${cfg.hostname}.service" ];
    # };
    #
    # security.acme.certs."${cfg.hostname}" = {
    #   group = "openldap";
    # };

    environment.persistence."/persistent" = {
      enable = lib.mkDefault false;
      directories = [
        "/var/lib/openldap/"
      ];
    };

    hostServices.restic.paths = [ "/persistent/var/lib/openldap" ];
  };
}
