{ pkgs, ... }: {
  imports = [ ./apps/nvim ./apps/zsh ];

  fonts.fontconfig.enable = true;

  home.sessionVariables.GTK_THEME = "Adwaita-dark";

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome.gnome-themes-extra;
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
