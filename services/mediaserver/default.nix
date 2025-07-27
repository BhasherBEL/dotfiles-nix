{ config, lib, ... }:
{
  imports = [
    ./jellyfin.nix
  ];

  options = {
    hostServices.mediaserver.enable = lib.mkEnableOption "Enable media server";
  };

  config = lib.mkIf config.hostServices.mediaserver.enable {
    hostServices = {
      nginx.enable = true;

      mediaserver = {
        jellyfin.enable = lib.mkDefault true;
      };
    };
  };
}
