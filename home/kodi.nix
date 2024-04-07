{ pkgs, inputs, ... }: {
  imports = [ ./shared/global ];

  home.username = "kodi";
  home.homeDirectory = "/home/kodi";

  home.stateVersion = "23.11";

  programs = {
    zsh.shellAliases = {
      nb = "sudo nixos-rebuild switch --flake /etc/nixos#media-center";
    };
  };
}
