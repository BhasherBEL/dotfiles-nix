{
  lib,
  config,
  pkgs,
  ...
}:
let
  themingcfg = config.modules.theming;
in
{
  options = {
    modules.theming.enable = lib.mkEnableOption "Enable theming";
  };

  config = lib.mkIf themingcfg.enable {
    stylix = {
      enable = true;
      image = ./assets/mountains_dark.jpg;
      polarity = "dark";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
    };

    home-manager.sharedModules = [
      {
        stylix.targets = {
          waybar.enable = false;
          rofi.enable = false;
          # Seems to be mandatory for GTK
          gnome.enable = true;
        };
      }
    ];

    # Slow down system
    #specialisation.day.configuration = {
    #  stylix = {
    #    image = lib.mkForce ./assets/mountains_light.jpg;
    #    polarity = lib.mkForce "light";
    #    base16Scheme = lib.mkForce "${pkgs.base16-schemes}/share/themes/catppuccin-latte.yaml";
    #  };
    #};
  };
}
