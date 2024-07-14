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
    swayosd.enable = true;
    swaync = {
      enable = true;
      settings = {
        positionX = "right";
        positionY = "bottom";
      };
    };
    udiskie = {
      enable = true;
      notify = true;
      automount = true;
    };
    swayidle = {
      enable = true;
      events = [
        {
          event = "before-sleep";
          command = "${pkgs.hyprlock}/bin/hyprlock";
        }
      ];
      timeouts = [
        {
          timeout = 600;
          command = "${pkgs.hyprlock}/bin/hyprlock";
        }
        {
          timeout = 1200;
          command = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
    };
  };

  # Required for udiskie to works on Wayland
  # https://github.com/nix-community/home-manager/issues/2064
  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
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
