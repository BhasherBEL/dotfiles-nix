{ config, ... }:
{
  programs.waybar.enable = true;

  home.file = {
    "${config.xdg.configHome}/hypr/src" = {
      source = ./config/hypr/src;
      recursive = true;
    };
    "${config.xdg.configHome}/hypr/autostart" = {
      source = ./config/hypr/autostart;
    };
    "${config.xdg.configHome}/hypr/hyprland.conf" = {
      source =
        if (builtins.getEnv "HOST" == "desktop") then
          ./config/hypr/hyprland-desktop.conf
        else
          ./config/hypr/hyprland-laptop.conf;
    };
    "${config.xdg.configHome}/swaync" = {
      source = ./config/swaync;
      recursive = true;
    };
    "${config.xdg.configHome}/tofi" = {
      source = ./config/tofi;
      recursive = true;
    };
    "${config.xdg.configHome}/waybar" = {
      source = ./config/waybar;
      recursive = true;
    };
  };
}
