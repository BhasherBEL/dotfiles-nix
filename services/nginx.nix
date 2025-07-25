{ lib, config, ... }:
{
  options = {
    hostServices.nginx.enable = lib.mkEnableOption "Enable Nginx reverse proxy";
  };

  config = lib.mkIf config.hostServices.nginx.enable {

    services.nginx = {
      enable = true;
      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
    };

    # security.acme = {
    #   acceptTerms = true;
    #   defaults = {
    #     email = "acme@bhasher.com";
    #     webroot = "/var/lib/acme/acme-challenge";
    #   };
    #
    #   certs."bhasher.com" = {
    #     domain = "bhasher.com";
    #     extraDomainNames = [ "*.bhasher.com" ];
    #   };
    # };

    users.users.nginx.extraGroups = [ "acme" ];

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];

    # environment.persistence."/nix/persist" = {
    #   directories = [
    #     "/var/lib/acme"
    #   ];
    # };
  };
}
