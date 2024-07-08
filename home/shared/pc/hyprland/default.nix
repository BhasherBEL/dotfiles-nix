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
        rofi-unwrapped = pkgs.nur.repos.bhasherbel.rofi-wayland-unwrapped;
        plugins = [
          (pkgs.rofi-calc.override { rofi-unwrapped = pkgs.nur.repos.bhasherbel.rofi-wayland-unwrapped; })
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
    hyprlock.enable = true;
  };

  services = {
    hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock";
          unlock_cmd = "killall -s SIGUSR1 hyprlock";
          before_sleep_cmd = "playerctl pause ; loginctl lock-session";
          after_wake_cmd = "hyprctl dispatch dpms on";
          ignore_dbus_inhibit = false;
        };
        listener = [
          {
            timeout = 150;
            on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0";
            on-resume = "brightnessctl -rd rgb:kbd_backlight";
          }
          {
            timeout = 240;
            on-timeout = "brightnessctl -s set 10";
            on-resume = "brightnessctl -r";
          }
          {
            timeout = 300;
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = 330;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
          {
            timeout = 600;
            on-timeout = "loginctl lock-session ; systemctl suspend";
          }
        ];
      };
    };
  };

  home.file = {
    "${config.xdg.configHome}/hypr/src" = {
      source = ./config/hypr/src;
      recursive = true;
    };
    "${config.xdg.configHome}/hypr/themes" = {
      source = ./config/hypr/themes;
      recursive = true;
    };
    "${config.xdg.configHome}/hypr/scripts" = {
      source = ./config/hypr/scripts;
      recursive = true;
      executable = true;
    };
    "${config.xdg.configHome}/hypr/hyprlock.conf" = {
      source = ./config/hypr/hyprlock.conf;
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
