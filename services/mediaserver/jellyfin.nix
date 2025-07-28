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
      nginx.virtualHosts."jellyfin.laptop.local.bhasher.com".locations."/" = {
        recommendedProxySettings = true;
        proxyPass = "http://127.0.0.1:8096";
      };
    };

    # environment.persistence."/nix/persist" = {
    #   directories = [
    #     "/var/lib/jellyfin"
    #   ];
    # };
  };
}
