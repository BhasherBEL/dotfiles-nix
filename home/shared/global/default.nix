{ pkgs, ... }:
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
  };
}
