{ ... }:
{
  imports = [
    ./nvim.nix
    ./apps/zsh
  ];

  fonts.fontconfig.enable = true;

  programs = {
    home-manager.enable = true;
    ranger.enable = true;
  };
}
