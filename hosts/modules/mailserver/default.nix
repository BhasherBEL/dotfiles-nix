{
  lib,
  inputs,
  config,
  ...
}:
let
  mailservercfg = config.hostModules.mailserver;
in
{
  options = {
    hostModules.mailserver.enable = lib.mkEnableOption "Enable mailserver";
  };

  config = lib.mkIf mailservercfg.enable {
    mailserver = {
      enable = true;
      fqdn = "mail.bhasher.com";
      domains = [
        "bhasher.com"
        "test.bhasher.com"
      ];
      enableImap = false; # Security
      enableImapSsl = true;
      enableManageSieve = true;

      loginAccounts.bhasher = {
        aliases = [
          "@bhasher.com"
          "@test.bhasher.com"
        ];
        catchAll = [
          "bhasher.com"
          "test.bhasher.com"
        ];
        hashedPasswordFile = "/run/secrets/mail/bhasher-bhasher.com";
      };
    };
  };
}
