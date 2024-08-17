{ lib, config, ... }:
let
  joplincfg = config.modules.joplin-desktop;
in
{
  options = {
    modules.joplin-desktop.enable = lib.mkEnableOption "Enable joplin-desktop";
  };

  config = lib.mkIf joplincfg.enable {
    programs.joplin-desktop = {
      enable = true;
      sync = {
        interval = "10m";
        target = "joplin-server";
      };
      extraConfig = {
        "sync.9.path" = "https://joplin.bhasher.com";
        "sync.9.username" = "joplin.lan@bhasher.com";
      };
    };
  };
}
