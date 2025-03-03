{
  lib,
  config,
  pkgs,
  ...
}:
let
  hyprlandcfg = config.modules.hyprland;
  metapccfg = config.modules.metaPc;
in
{
  options = {
    modules.hyprland = {
      enable = lib.mkEnableOption "Enable hyprland";
    };
  };

  config = lib.mkIf hyprlandcfg.enable {
    assertions = [
      {
        assertion = metapccfg.enable;
        message = "Meta module PC is required";
      }
    ];

    home.file = {
      "${config.xdg.configHome}/hypr/scripts/decrease_scale.sh" = {
        text = ''
          current=$(wlr-randr --output eDP-1 | grep 'Scale:' | awk '{print $2}')
          new=$(echo "$current - 0.25" | bc)

          wlr-randr --output eDP-1 --scale $new
        '';
        executable = true;
      };
      "${config.xdg.configHome}/hypr/scripts/increase_scale.sh" = {
        text = ''
          current=$(wlr-randr --output eDP-1 | grep 'Scale:' | awk '{print $2}')
          new=$(echo "$current + 0.25" | bc)

          wlr-randr --output eDP-1 --scale $new
        '';
        executable = true;
      };
    };

    wayland.windowManager.hyprland = {
      enable = true;
      package = pkgs.hyprland;
      systemd = {
        enable = true;
        enableXdgAutostart = true;
      };
      settings = {
        exec-once = [
          "${pkgs.swww}/bin/swww-daemon"
          "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator"
          "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch cliphlist store"
          "${pkgs.wl-clipboard}/bin/wl-paste --type image --watch cliphlist store"
        ];
        monitor = metapccfg.monitors;
        workspace =
          let
            workspacesPerMonitor = 10;

            generateWorkspaces =
              i: monitor:
              let
                monitorName = builtins.elemAt (lib.splitString "," monitor) 0;
                start = i * workspacesPerMonitor + 1;
                end = (i + 1) * workspacesPerMonitor;
              in
              [ "${monitorName},${toString (i + 1)}" ]
              ++ map (workspace: "${toString workspace},monitor:${monitorName}") (lib.range start end);
          in
          lib.concatLists (lib.imap0 generateWorkspaces metapccfg.monitors);

        "$mainMod" = "SUPER";

        bind = [
          "$mainMod, RETURN, exec, ${pkgs.kitty}/bin/kitty"
          "$mainMod, C, killactive, "
          "$mainMod, V, togglefloating, "
          "$mainMod, D, exec, rofi -show drun"
          "$mainMod, P, pseudo,"
          "$mainMod, J, togglesplit,"
          "$mainMod, L, exec, ${pkgs.hyprlock}/bin/hyprlock"

          # Media keys
          ", PRINT, exec, ${pkgs.hyprshot}/bin/hyprshot -m region --clipboard-only"
          "SHIFT, PRINT, exec, ${pkgs.hyprshot}/bin/hyprshot -m region -o $HOME/Pictures/Screenshots"
          ", Home, exec, sh $HOME/.config/hypr/scripts/increase_scale.sh"
          ", End, exec, sh $HOME/.config/hypr/scripts/decrease_scale.sh"
          ", XF86HomePage, exec, firefox"
          ", XF86Mail, exec, ${pkgs.thunderbird}/bin/thunderbird"
          ", XF86Calc, exec, rofi -show calc"

          # Move focus with mainMod + arrow keys
          "$mainMod, left, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"

          # Switch workspaces with mainMod + [0-9]
          "$mainMod, ampersand, exec, hyprsome workspace 1"
          "$mainMod, eacute, exec, hyprsome workspace 2"
          "$mainMod, quotedbl, exec, hyprsome workspace 3"
          "$mainMod, apostrophe, exec, hyprsome workspace 4"
          "$mainMod, parenleft, exec, hyprsome workspace 5"
          "$mainMod, minus, exec, hyprsome workspace 6"
          "$mainMod, egrave, exec, hyprsome workspace 7"
          "$mainMod, underscore, exec, hyprsome workspace 8"
          "$mainMod, ccedilla, exec, hyprsome workspace 9"
          "$mainMod, agrave, exec, hyprsome workspace 10"

          # Move active window to a workspace with mainMod + SHIFT + [0-9]
          "$mainMod SHIFT, ampersand, exec, hyprsome movefocus 1"
          "$mainMod SHIFT, eacute, exec, hyprsome movefocus 2"
          "$mainMod SHIFT, quotedbl, exec, hyprsome movefocus 3"
          "$mainMod SHIFT, apostrophe, exec, hyprsome movefocus 4"
          "$mainMod SHIFT, parenleft, exec, hyprsome movefocus 5"
          "$mainMod SHIFT, minus, exec, hyprsome movefocus 6"
          "$mainMod SHIFT, egrave, exec, hyprsome movefocus 7"
          "$mainMod SHIFT, underscore, exec, hyprsome movefocus 8"
          "$mainMod SHIFT, ccedilla, exec, hyprsome movefocus 9"
          "$mainMod SHIFT, agrave, exec, hyprsome movefocus 10"

          # Move active window to workspace without changing focus with mainMod + CTRL + [0-9]
          "$mainMod CTRL, ampersand, exec, hyprsome move 1"
          "$mainMod CTRL, eacute, exec, hyprsome move 2"
          "$mainMod CTRL, quotedbl, exec, hyprsome move 3"
          "$mainMod CTRL, apostrophe, exec, hyprsome move 4"
          "$mainMod CTRL, parenleft, exec, hyprsome move 5"
          "$mainMod CTRL, minus, exec, hyprsome move 6"
          "$mainMod CTRL, egrave, exec, hyprsome move 7"
          "$mainMod CTRL, underscore, exec, hyprsome move 8"
          "$mainMod CTRL, ccedilla, exec, hyprsome move 9"
          "$mainMod CTRL, agrave, exec, hyprsome move 10"

          # Move active window to neighboring monitor with mainMod + SHIFT + arrow keys
          "$mainMod SHIFT, left, movewindow, l"
          "$mainMod SHIFT, right, movewindow, r"
          "$mainMod SHIFT, up, movewindow, u"
          "$mainMod SHIFT, down, movewindow, d"

          # Example special workspace (scratchpad)
          "$mainMod, S, togglespecialworkspace, magic"
          "$mainMod SHIFT, S, movetoworkspace, special:magic"

          # Scroll through existing workspaces with mainMod + scroll
          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"
        ];
        # Move/resize windows with mainMod + LMB/RMB and dragging
        bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];
        # Allow volume and brightness when locked
        bindle = [
          ", XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise --max-volume 150"
          ", XF86AudioLowerVolume, exec, swayosd-client --output-volume lower --max-volume 150"
          ", XF86MonBrightnessUp, exec, swayosd-client --brightness +5"
          ", XF86MonBrightnessDown, exec, swayosd-client --brightness -5"
        ];
        bindl = [
          ", XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"
          ", XF86AudioMicMute, exec, swayosd-client --input-volume mute-toggle"
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioNext, exec, playerctl next"
          ", XF86AudioPrev, exec, playerctl previous"
          ", XF86AudioStop, exec, playerctl stop"
        ];

        input = {
          kb_layout = "fr,be";
          kb_options = "caps:swapescape,grp:win_space_toggle";
          numlock_by_default = true;
          follow_mouse = 1;
          touchpad = {
            natural_scroll = "yes";
          };
          sensitivity = 0;
        };

        general = {
          gaps_in = 5;
          gaps_out = 10;
          border_size = 2;
          #"col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
          #"col.inactive_border" = "rgba(595959aa)";
          layout = "dwindle";
          allow_tearing = false;
        };

        decoration = {
          rounding = 10;

          blur = {
            enabled = true;
            size = 3;
            passes = 1;
          };

          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
          };
        };

        animations = {
          enabled = "yes";
          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
        };

        dwindle = {
          pseudotile = "yes";
          preserve_split = "yes";
        };

        master = {
          orientation = "right";
        };

        gestures = {
          workspace_swipe = true;
        };

        misc = {
          force_default_wallpaper = -1;
        };

        # TODO: move to HM directly
        env = [
          "XCURSOR_SIZE,18"
          "QT_QPA_PLATFORM,wayland"
          "QT_QPA_PLATFORMTHEME,qt5ct"
          "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
          "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        ];

        windowrulev2 = [
          "idleinhibit fullscreen, fullscreen:1"
          "tile, class:^(ONLYOFFICE Desktop Editors|DesktopEditors)$"
          "tile, class:^(ghidra)(.*)$"
          "opacity 0.9, class:(kitty)"
          "float, class:(firefox), title:(Picture-in-Picture)"
          "pin, class:(firefox), title:(Picture-in-Picture)"
          "keepaspectratio, class:(firefox), title:(Picture-in-Picture)"
        ];
      };
    };
  };
}
