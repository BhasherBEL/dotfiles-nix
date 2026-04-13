{
  lib,
  config,
  ...
}:
let
  cfg = config.hostServices.mailserver;
  # mailcfg = config.mailserver;
in
{
  # imports = [
  #   inputs.simple-nixos-mailserver.nixosModule
  # ];

  options = {
    hostServices.mailserver = {
      enable = lib.mkEnableOption "Enable mailserver";
      fqdn = lib.mkOption {
        type = lib.types.str;
        default = "mail.test.bhasher.com";
        description = "The hostname for mealie";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets = {
      "services/mail/bhasher-bhasher.com" = { };
    };

    # mailserver = {
    #   enable = true;
    #   stateVersion = 3;
    #   openFirewall = false;
    #   fqdn = cfg.fqdn;
    #   domains = [
    #     "bhasher.com"
    #     "test.bhasher.com"
    #   ];
    #   certificateScheme = "acme-nginx";
    #
    #   enableImap = false;
    #   enableImapSsl = true;
    #   # enableManageSieve = true;
    #   enableSubmissionSsl = true;
    #
    #   loginAccounts.bhasher = {
    #     aliases = [
    #       "@bhasher.com"
    #       "@test.bhasher.com"
    #     ];
    #     catchAll = [
    #       "bhasher.com"
    #       "test.bhasher.com"
    #     ];
    #     hashedPasswordFile = "/run/secrets/services/mail/bhasher-bhasher.com";
    #   };
    # };

    security.acme = {
      acceptTerms = true;
      defaults = {
        email = "acme@bhasher.com";
        server = "https://acme-v02.api.letsencrypt.org/directory";
        group = "acme";
      };
    };

    networking.firewall = {
      enable = true;
      # allowedTCPPorts = [
      #   25
      # ];
      interfaces.wg0 = {
        # allowedTCPPorts =
        #   lib.optional mailcfg.enableSubmissionSsl 465
        #   ++ lib.optional mailcfg.enableImapSsl 993
        #   ++ lib.optional mailcfg.enablePop3Ssl 995
        #   ++ lib.optional mailcfg.enableManageSieve 4190;
      };
    };
  };
}
