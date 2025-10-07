{ lib, config, ... }:
let
  cfg = config.hostServices.mediaserver.transmission;
in
{
  options = {
    hostServices.mediaserver.transmission = {
      enable = lib.mkEnableOption "Enable transmission";
      hostname = lib.mkOption {
        type = lib.types.str;
        default = "transmission.bhasher.com";
        description = "The hostname of transmission";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      transmission = {
        enable = true;
        settings = {
          download-dir = "/mnt/external/media/download/complete";
          incomplete-dir = "/mnt/external/media/download/incomplete";
          watch-dir = "/mnt/external/media/download/watch";
          watch-dir-enabled = true;
          rpc-port = 9092; # 9091 is already used by authelia
          rpc-host-whitelist = cfg.hostname;
          rpc-host-whitelist-enabled = true;
        };
      };
      nginx.virtualHosts."${cfg.hostname}" = {
        forceSSL = true;
        enableACME = true;
        locations = {
          "/" = {
            proxyPass = "http://127.0.0.1:9092/";
            recommendedProxySettings = true;
            extraConfig = "include ${config.hostServices.auth.authelia.snippets.request};";
          };
          "/internal/authelia/authz" = {
            recommendedProxySettings = false;
            extraConfig = "include ${config.hostServices.auth.authelia.snippets.location};";
          };
        };
      };
    };

    environment.persistence."/persistent" = {
      enable = lib.mkDefault false;
      directories = [
        {
          directory = "/var/lib/transmission";
          user = config.services.transmission.user;
          group = config.services.transmission.group;
        }
      ];
    };
  };
}
