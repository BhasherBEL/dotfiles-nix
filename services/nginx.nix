{
  lib,
  config,
  ...
}:
let
  cfg = config.hostServices.nginx;
in
{
  options = {
    hostServices.nginx = {
      enable = lib.mkEnableOption "Enable Nginx reverse proxy";
      http = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Open HTTP port (80)";
      };
      https = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Open HTTPS port (443)";
      };
      https-bis = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Open HTTPS-bis port (444)";
      };
    };
  };

  config = lib.mkIf cfg.enable {

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
        locations."/.well-known/acme-challenge/" = {
          root = "/var/lib/acme/acme-challenge";
        };
        listen =
          lib.optional cfg.http {
            addr = "0.0.0.0";
            port = 80;
          }
          ++ lib.optional cfg.https {
            addr = "0.0.0.0";
            port = 443;
            ssl = true;
          }
          ++ lib.optional cfg.https-bis {
            addr = "0.0.0.0";
            port = 444;
            ssl = true;
          };
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

    networking.firewall.allowedTCPPorts =
      lib.optional cfg.http 80 ++ lib.optional cfg.https 443 ++ lib.optional cfg.https-bis 444;

    environment.persistence."/persistent" = {
      enable = lib.mkDefault false;
      directories = [
        "/var/lib/acme"
      ];
    };

    hostServices.restic.paths = [ "/persistent/var/lib/acme" ];

  };
}
