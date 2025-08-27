{
  lib,
  config,
  pkgs,
  ...
}:
let
  jellyfin-media-playercfg = config.modules.jellyfin-media-player;
in
{
  options = {
    modules.jellyfin-media-player.enable = lib.mkEnableOption "Enable jellyfin-media-player";
  };

  config = lib.mkIf jellyfin-media-playercfg.enable {

    environment.systemPackages = with pkgs; [
      jellyfin-media-player
    ];

    # https://github.com/NixOS/nixpkgs/pull/435067
    nixpkgs.config.permittedInsecurePackages = [
      "qtwebengine-5.15.19"
    ];
  };
}
