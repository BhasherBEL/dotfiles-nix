{
  lib,
  config,
  inputs,
  ...
}:
let
  cfg = config.hostServices.mailserver;
  mailcfg = config.mailserver;
in
{
  imports = [
    inputs.simple-nixos-mailserver.nixosModule
  ];

  options = {
    hostServices.mailserver = {
      enable = lib.mkEnableOption "Enable mailserver";
      fqdn = lib.mkOption {
        type = lib.types.str;
        default = "mail01.bhasher.com";
        description = "The hostname for mealie";
      };
      domains = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ "bhasher.com" ];
      };
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets = {
      "services/mail/bhasher-bhasher.com".restartUnits = [ "dovecot.service" ];
      "services/mail/scaleway-tem".restartUnits = [ "postfix.service" ];
    };

    mailserver = {
      enable = true;
      stateVersion = 5;
      openFirewall = false;
      fqdn = cfg.fqdn;
      domains = cfg.domains;
      x509.useACMEHost = cfg.fqdn;

      enableImap = false;
      enableImapSsl = true;
      enableSubmission = false;
      enableSubmissionSsl = true;
      enablePop3 = false;
      enablePop3Ssl = false;
      enableManageSieve = true;

      virusScanning = false;
      fullTextSearch.enable = false;

      accounts."main@bhasher.com" = {
        aliases = map (d: "@${d}") cfg.domains;
        hashedPasswordFile = config.sops.secrets."services/mail/bhasher-bhasher.com".path;
      };

      dkim.domains = lib.genAttrs cfg.domains (_: {
        selectors."rsa-2026-09" = { };
      });
    };

    services = {
      nginx.virtualHosts.${cfg.fqdn} = {
        enableACME = true;
        locations."/".return = "444";
      };
      postfix.settings.main = {
        relayhost = [ "[smtp.tem.scaleway.com]:2587" ];
        smtp_sasl_auth_enable = true;
        smtp_sasl_password_maps = "texthash:${config.sops.secrets."services/mail/scaleway-tem".path}";
        smtp_sasl_security_options = "noanonymous";
        smtp_sasl_tls_security_options = "noanonymous";
        smtp_tls_security_level = lib.mkForce "secure";
      };
    };

    networking.firewall = {
      enable = true;
      allowedTCPPorts = [
        25
      ];
      interfaces.wg0 = {
        allowedTCPPorts =
          lib.optional mailcfg.enableSubmissionSsl 465
          ++ lib.optional mailcfg.enableImapSsl 993
          ++ lib.optional mailcfg.enablePop3Ssl 995
          ++ lib.optional mailcfg.enableManageSieve 4190;
      };
    };

    hostServices.restic.paths = [
      "/var/vmail"
      "/var/dkim"
      "/var/lib/redis-rspamd"
    ];
  };
}
