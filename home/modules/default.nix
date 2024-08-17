{ ... }:
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
  ];

  fonts.fontconfig.enable = true;

  programs.home-manager.enable = true;

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
  };

  modules = {
    zsh.enable = true;
    ranger.enable = true;
    git.enable = true;
    ssh.enable = true;
    nvim.enable = true;
  };
}
