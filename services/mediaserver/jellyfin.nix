{ lib, config, ... }:
{
  options = {
    hostServices.mediaserver.jellyfin.enable = lib.mkEnableOption "Enable Jellyfin media server";
  };

  config = lib.mkIf config.hostServices.mediaserver.jellyfin.enable {
    services.jellyfin = {
      enable = true;
    };

    # environment.persistence."/nix/persist" = {
    #   directories = [
    #     "/var/lib/jellyfin"
    #   ];
    # };
  };
}
