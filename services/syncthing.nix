{
  lib,
  config,
  ...
}:
let
  cfg = config.hostServices.syncthing;
in
{
  options = {
    hostServices.syncthing = {
      enable = lib.mkEnableOption "Enable Syncthing";
      hostname = lib.mkOption {
        type = lib.types.str;
        default = "syncthing.bhasher.com";
        description = "The hostname for syncthing.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets = {
      "services/syncthing/cert.pem" = {
        owner = config.services.syncthing.user;
        group = config.services.syncthing.group;
      };
      "services/syncthing/key.pem" = {
        owner = config.services.syncthing.user;
        group = config.services.syncthing.group;
      };
    };

    services = {
      syncthing = {
        enable = true;
        dataDir = "/var/lib/syncthing";
        overrideDevices = true;
        overrideFolders = true;
        key = config.sops.secrets."services/syncthing/key.pem".path;
        cert = config.sops.secrets."services/syncthing/cert.pem".path;

        settings = {
          gui.insecureSkipHostcheck = true;
          options.urAccepted = -1;
          devices = {
            "desktop".id = "OAPHG7Q-L22S5R5-YGAYL46-UX2COKM-ICLEQT5-QVY5O4R-LFSS65F-KYFGCAW";
          };
          folders = {
            "SyncDocuments" = {
              id = "e76wn-jhcuj";
              path = "/srv/syncthing/SyncDocuments";
              devices = [ "desktop" ];
              versioning = {
                type = "trashcan";
                params.cleanoutDays = "30";
              };
            };
          };
        };
      };
      nginx.virtualHosts."${cfg.hostname}" = {
        forceSSL = true;
        enableACME = true;
        locations = {
          "/" = {
            recommendedProxySettings = true;
            proxyPass = "http://127.0.0.1:8384";
            extraConfig = "include ${config.hostServices.auth.authelia.snippets.request};";
          };
          "/internal/authelia/authz" = {
            recommendedProxySettings = false;
            extraConfig = "include ${config.hostServices.auth.authelia.snippets.location};";
          };
        };
      };
    };

    networking.firewall = {
      allowedTCPPorts = [
        22000
      ];
      allowedUDPPorts = [
        22000
        21027
      ];
    };

    environment.persistence."/persistent" = {
      enable = lib.mkDefault false;
      directories = [
        {
          directory = "/srv/syncthing"; # Synced data SHOULD NOT BE BACKED UP
          user = config.services.syncthing.user;
          group = config.services.syncthing.group;
        }
      ];
    };
  };
}
