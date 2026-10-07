{ lib, config, ... }:
let
  cfg = config.hostServices.navidrome;
in
{
  options = {
    hostServices.navidrome = {
      enable = lib.mkEnableOption "Enable navidrome";
      hostname = lib.mkOption {
        type = lib.types.str;
        default = "music.bhasher.com";
        description = "The hostname for navidrome";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      navidrome = {
        enable = true;
        settings = {
          ReverseProxyWhitelist = "127.0.0.1/32";
          ReverseProxyUserHeader = "Remote-User";
          MusicFolder = "/mnt/external/media/music/";
        };
      };
      nginx.virtualHosts = {
        "${cfg.hostname}" = {
          forceSSL = true;
          enableACME = true;
          locations = {
            "/" = {
              proxyPass = "http://127.0.0.1:${toString config.services.navidrome.settings.Port}";
              recommendedProxySettings = true;
              extraConfig = "include ${config.hostServices.auth.authelia.snippets.request};";
            };
            "/rest/" = {
              proxyPass = "http://127.0.0.1:${toString config.services.navidrome.settings.Port}";
              recommendedProxySettings = true;
              extraConfig = ''
                proxy_set_header Remote-User "";
              '';
            };
            "/internal/authelia/authz" = {
              recommendedProxySettings = false;
              extraConfig = "include ${config.hostServices.auth.authelia.snippets.location};";
            };
          };
        };
      };
    };

    environment.persistence."/persistent" = {
      enable = lib.mkDefault false;
      directories = [
        {
          directory = "/var/lib/navidrome";
          user = config.services.navidrome.user;
          group = config.services.navidrome.group;
        }
      ];
    };

    hostServices = {
      restic.paths = [ "/persistent/var/lib/navidrome" ];
      monitoring.gatus.endpoints = [ "https://${cfg.hostname}" ];
    };
  };
}
