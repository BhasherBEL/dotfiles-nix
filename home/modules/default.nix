{ lib, ... }:
{
  # TODO: Find a way to avoid to list them here

  imports = [
    ./pc.nix

    ./firefox
    ./git
    ./ssh
    ./syncthing
    ./joplin-desktop
    ./kdeconnect
    ./zsh
    ./catppuccin
    ./ranger
    ./hyprland
    ./hyprlock
    ./hypridle
    ./rofi
    ./activitywatch
    ./swaync
    ./udiskie
    ./nvim
    ./waybar
    ./kitty
    ./tmux
    ./alacritty
    ./yazi
  ];

  fonts.fontconfig.enable = true;

  programs.home-manager.enable = true;

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
  };

  modules = {
    zsh.enable = lib.mkDefault true;
    yazi.enable = lib.mkDefault true;
    git.enable = lib.mkDefault true;
    ssh.enable = lib.mkDefault true;
    nvim.enable = lib.mkDefault true;
  };
}
