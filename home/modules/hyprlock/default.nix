{
  lib,
  config,
  pkgs,
  ...
}:
let
  hyprlockcfg = config.modules.hyprlock;
in
{
  options = {
    modules.hyprlock.enable = lib.mkEnableOption "Enable hyprlock";
  };

  config = lib.mkIf hyprlockcfg.enable {
    programs.hyprlock = {
      enable = true;
      sourceFirst = true;
      settings = {
        # TODO overlay
        source = ''${
          pkgs.catppuccin.override {
            variant = "macchiato";
            themeList = [ "hyprland" ];
          }
        }/hyprland/macchiato.conf'';

        "$accent" = "$mauve";
        "$accentAlpha" = "$mauveAlpha";
        "$font" = "JetBrainsMono Nerd Font";

        # GENERAL
        general = {
          disable_loading_bar = true;
          hide_cursor = true;
          grace = 5;
        };

        # BACKGROUND
        background = {
          #path = "${config.xdg.configHome}/assets/backgrounds/mountains_dark.jpg";
          blur_passes = 2;
          contrast = 1;
          brightness = 0.5;
        };

        input-field = {
          hide_input = false;
        };

        # TIME
        label = [
          {
            text = "cmd[update:30000] echo \"$(date +\"%R\")\"";
            color = "$text";
            font_size = 90;
            font_family = "$font";
            position = "-30, 0";
            halign = "right";
            valign = "top";
          }

          # DATE
          {
            text = "cmd[update:43200000] echo \"$(date +\"%A, %d %B %Y\")\"";
            color = "$text";
            font_size = 25;
            font_family = "$font";
            position = "-30, -150";
            halign = "right";
            valign = "top";
          }
        ];

        # USER AVATAR

        image = [
          {
            path = "~/.face.png";
            size = 100;
            border_color = "$accent";

            position = "0, 75";
            halign = "center";
            valign = "center";
          }
        ];
      };
    };
  };
}
