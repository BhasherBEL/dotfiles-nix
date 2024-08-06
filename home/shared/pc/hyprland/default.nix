{ config, ... }:
{
  imports = [
    ./hyprland.nix
    ./rofi
    ./hyprlock.nix
    ./waybar
    ./hypridle.nix
    ./swaync.nix
  ];

  services = {
    swayosd.enable = true;
    udiskie = {
      enable = true;
      notify = true;
      automount = false;
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
    "${config.xdg.configHome}/assets" = {
      source = ./assets;
      recursive = true;
    };
  };
}
