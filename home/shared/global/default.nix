{ pkgs, ... }:
{
  imports = [
    ./apps/nvim
    ./apps/zsh
  ];

  fonts.fontconfig.enable = true;

  home.sessionVariables.GTK_THEME = "Breeze-Dark";

  gtk = {
    enable = true;
    theme = {
      name = "Breeze-Dark";
      package = pkgs.libsForQt5.breeze-gtk;
    };
  };

  programs = {
    home-manager.enable = true;

    kitty = {
      shellIntegration.enableZshIntegration = true;
      settings.confirm_os_window_close = -1;
    };
  };
}
