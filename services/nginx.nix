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

    security.acme = {
      acceptTerms = true;
      defaults = {
        email = "acme@bhasher.com";
        server = "https://acme-v02.api.letsencrypt.org/directory";
        group = "acme";
      };
      maxConcurrentRenewals = 1;
    };

    users.users.nginx.extraGroups = [ "acme" ];

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];

    environment.persistence."/persistent" = {
      enable = lib.mkDefault false;
      directories = [
        "/var/lib/acme"
      ];
    };
  };
}
