{ pkgs, ... }:
{
  imports = [
    ./hyprland
    ./apps/desktop/firefox.nix
    ./apps/desktop/activitywatch.nix
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

  xdg = {
    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = "firefox.desktop";
        "inode/directory" = "kitty-ranger.desktop";
      };
    };
    # Thanks to @megaaa13
    desktopEntries = {
      kitty-ranger = {
        name = "Open with Ranger";
        exec = "kitty ranger";
        terminal = false;
        mimeType = [ "inode/directory" ];
        noDisplay = true;
      };
    };
  };

  programs = {
    kitty = {
      enable = true;
      shellIntegration.enableZshIntegration = true;
      settings.confirm_os_window_close = -1;
      font = {
        name = "Hack Nerd Font Mono";
        package = pkgs.nerdfonts;
      };
      theme = "Catppuccin-Mocha";
    };
  };
}
