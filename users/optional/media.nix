{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
{

  options.media = {
    vlc = mkOption {
      type = types.bool;
      default = true;
      description = "Enable VLC media player";
    };
    jellyfin = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Jellyfin media server";
    };
  };

  config.environment.systemPackages =
    optional config.media.vlc pkgs.vlc
    ++ optional config.media.jellyfin pkgs.jellyfin-media-player;
}
