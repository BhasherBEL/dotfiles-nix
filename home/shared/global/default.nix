{ pkgs, lib, ... }:
{
  imports = [
    ./nvim.nix
    ./apps/zsh
  ];

  # TODO prevent unexpected use
  home.packages = with pkgs; [ home-manager ];

  fonts.fontconfig.enable = true;

  programs = {
    home-manager.enable = true;
    ranger.enable = true;
    kitty = {
      enable = true;
      shellIntegration.enableZshIntegration = true;
      settings.confirm_os_window_close = -1;
      font = {
        name = "Hack Nerd Font Mono";
        package = pkgs.nerdfonts;
      };
      theme = lib.mkDefault "Catppuccin-Macchiato";
    };
  };
}
