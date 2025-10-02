{
  lib,
  config,
  pkgs,
  ...
}:
let
  roficfg = config.modules.rofi;
in
{
  options = {
    modules.rofi.enable = lib.mkEnableOption "Enable rofi";
  };

  config = lib.mkIf roficfg.enable {
    programs.rofi = {
      enable = true;
      plugins = [
        pkgs.rofi-calc
        pkgs.rofi-emoji
      ];
      terminal = "${pkgs.alacritty}/bin/alacritty";
      theme = "${config.xdg.configHome}/rofi/themes/type1-style8.rasi";
      extraConfig = {
        # sorting-method = "alnum";
        sorting-method = "normal";
        sort = true;
      };
    };

    home.file = {
      "${config.xdg.configHome}/rofi/themes" = {
        source = ./themes;
        recursive = true;
      };
    };
  };
}
