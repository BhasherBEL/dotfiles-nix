{ config, lib, ... }:
{
  imports = [
    ./jellyfin.nix
    ./servarr.nix
  ];

  options = {
    hostServices.mediaserver = {
      enable = lib.mkEnableOption "Enable media server";
      analytics = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable analytics for the media server";
      };
    };
  };

  config = lib.mkIf config.hostServices.mediaserver.enable {
    hostServices = {
      nginx.enable = true;

      mediaserver = {
        jellyfin.enable = lib.mkDefault true;
        servarr.enable = lib.mkDefault true;
      };
    };
  };
}
