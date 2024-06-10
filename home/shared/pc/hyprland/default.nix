{
  pkgs,
  config,
  osConfig,
  ...
}:
{
  programs = {
    waybar.enable = true;
    rofi = {
      enable = true;
      package = pkgs.rofi-wayland.override {
        rofi-unwrapped = pkgs.nur.repos.bhasherbel.rofi-wayland;
        plugins = [
          (pkgs.rofi-calc.override { rofi-unwrapped = pkgs.nur.repos.bhasherbel.rofi-wayland; })
          #pkgs.rofi-emoji
        ];
      };
      terminal = "kitty";
      theme = "~/.config/rofi/themes/type1-style8.rasi";
      extraConfig = {
        sorting-method = "alnum";
        sort = true;
      };
    };
  };

  home.file = {
    "${config.xdg.configHome}/hypr/src" = {
      source = ./config/hypr/src;
      recursive = true;
    };
    "${config.xdg.configHome}/hypr/scripts" = {
      source = ./config/hypr/scripts;
      recursive = true;
      executable = true;
    };
    "${config.xdg.configHome}/hypr/autostart" = {
      source = ./config/hypr/autostart;
    };
    "${config.xdg.configHome}/hypr/hyprland.conf" = {
      source =
        if (osConfig.networking.hostName == "desktop") then
          ./config/hypr/hyprland-desktop.conf
        else if (osConfig.networking.hostName == "laptop") then
          ./config/hypr/hyprland-laptop.conf
        else
          ./config/hypr/hyprland-generic.conf;
    };
    "${config.xdg.configHome}/hypr/hyprland-generic.conf" = {
      source = ./config/hypr/hyprland-generic.conf;
    };
    "${config.xdg.configHome}/swaync" = {
      source = ./config/swaync;
      recursive = true;
    };
    "${config.xdg.configHome}/rofi" = {
      source = ./config/rofi;
      recursive = true;
    };
    "${config.xdg.configHome}/waybar" = {
      source = ./config/waybar;
      recursive = true;
    };
  };
}
