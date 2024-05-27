{ pkgs, ... }:
{
  imports = [
    ./hyprland
    ./apps/desktop/firefox.nix
  ];

  home = {
    sessionVariables = {
      GTK_THEME = "Breeze-Dark";
      MOZ_ENABLE_WAYLAND = "1";
    };

    pointerCursor = {
      gtk.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 16;
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Breeze-Dark";
      package = pkgs.libsForQt5.breeze-gtk;
    };
  };
}
