{ lib, config, ... }:
{
  options = {
    hostServices.mediaserver.jellyfin.enable = lib.mkEnableOption "Enable Jellyfin media server";
  };

  config = lib.mkIf config.hostServices.mediaserver.jellyfin.enable {
    services = {
      jellyfin = {
        enable = true;
        dataDir = "/var/lib/jellyfin";
      };
      nginx.virtualHosts."jellyfin.bhasher.com" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          recommendedProxySettings = true;
          proxyPass = "http://127.0.0.1:8096";
        };
      };
    };

    environment.persistence."/persistent" = {
      enable = lib.mkDefault false;
      directories = [
        "/var/lib/jellyfin"
      ];
    };
  };
}
