{
  lib,
  config,
  ...
}:
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
      recommendedProxySettings = true;

      virtualHosts."default" = {
        default = true;
        enableACME = false;
        forceSSL = false;
        rejectSSL = true;
        locations."/".return = "404";
        listen = [
          {
            addr = "0.0.0.0";
            port = 80;
          }
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
      };
    };

    security.acme = {
      acceptTerms = true;
      defaults = {
        email = "acme@bhasher.com";
        server = "https://acme-v02.api.letsencrypt.org/directory";
        # server = "https://acme-staging-v02.api.letsencrypt.org/directory";
        group = "acme";
      };
      maxConcurrentRenewals = 1;
    };

    users.users.nginx.extraGroups = [ "acme" ];

    networking.firewall.allowedTCPPorts = [
      80
      443
      444
    ];

    environment.persistence."/persistent" = {
      enable = lib.mkDefault false;
      directories = [
        "/var/lib/acme"
      ];
    };

  };
}
