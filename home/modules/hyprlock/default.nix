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
          grace = 15;
        };

        # BACKGROUND
        background = [
          {
            #path = ~/.config/background
            blur_passes = 0;
            color = "rgba(25, 20, 30, 1.0)";
          }
        ];

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

        # INPUT FIELD
        input-field = [
          {
            size = "300, 60";
            outline_thickness = 4;
            dots_size = 0.2;
            dots_spacing = 0.2;
            dots_center = true;
            outer_color = "$accent";
            inner_color = "$surface0";
            font_color = "$text";
            fade_on_empty = false;
            placeholder_text = "<span foreground=\"##$textAlpha\"> <i>Logged in as</i> <span foreground=\"##$accentAlpha\">$USER</span></span>";
            hide_input = false;
            check_color = "$accent";
            fail_color = "$red";
            fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
            capslock_color = "$yellow";
            position = "0, -35";
            halign = "center";
            valign = "center";
          }
        ];
      };
    };
  };
}
