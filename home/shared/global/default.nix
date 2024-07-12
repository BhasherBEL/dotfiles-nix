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

    kitty = {
      shellIntegration.enableZshIntegration = true;
      settings.confirm_os_window_close = -1;
    };
  };
}
