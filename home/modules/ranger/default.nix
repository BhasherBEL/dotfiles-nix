{ lib, config, ... }:
let
  rangercfg = config.modules.ranger;
in
{
  options = {
    modules.ranger.enable = lib.mkEnableOption "Enable ranger";
  };

  config = lib.mkIf rangercfg.enable {
    programs.ranger = {
      # TODO: Improve config
      enable = true;
    };
    xdg = {
      mimeApps = {
        defaultApplications = {
          "inode/directory" = "kitty-ranger.desktop";
        };
      };
      # Thanks to @megaaa13
      desktopEntries = {
        kitty-ranger = {
          name = "Open with Ranger";
          exec = "kitty ranger";
          terminal = false;
          mimeType = [ "inode/directory" ];
          noDisplay = true;
        };
      };
    };
  };
}
