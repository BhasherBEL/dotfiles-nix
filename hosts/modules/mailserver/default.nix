{
  lib,
  inputs,
  config,
  ...
}:
let
  cfg = config.hostModules.mailserver;
in
{
  # imports = [
  #   inputs.simple-nixos-mailserver.nixosModule
  # ];
  #
  # options = {
  #   hostModules.mailserver.enable = lib.mkEnableOption "Enable mailserver";
  # };
  #
  # config = lib.mkIf cfg.enable {
  #   mailserver = {
  #     enable = true;
  #     fqdn = "mail.bhasher.com";
  #     domains = [
  #       "bhasher.com"
  #       "test.bhasher.com"
  #     ];
  #     enableImap = false;
  #     enableImapSsl = true;
  #     enableManageSieve = true;
  #
  #     loginAccounts.bhasher = {
  #       aliases = [
  #         "@bhasher.com"
  #         "@test.bhasher.com"
  #       ];
  #       catchAll = [
  #         "bhasher.com"
  #         "test.bhasher.com"
  #       ];
  #       hashedPasswordFile = "/run/secrets/mail/bhasher-bhasher.com";
  #     };
  #   };
  # };
}
