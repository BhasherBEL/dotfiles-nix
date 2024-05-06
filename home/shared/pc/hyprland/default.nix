{ config, ... }:
{
  programs.waybar.enable = true;

  home.file = {
    "${config.xdg.configHome}/hypr" = {
      source = ./config/hypr;
      recursive = true;
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
