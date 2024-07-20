{
  pkgs,
  config,
  osConfig,
  ...
}:
{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd = {
      enable = true;
      enableXdgAutostart = true;
    };
    settings = {
      exec-once = [
        "${pkgs.swww}/bin/swww-daemon"
        "${pkgs.swww}/bin/swww img ${config.xdg.configHome}/assets/backgrounds/mountains_dark.jpg"
        "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator"
        "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch cliphlist store"
        "${pkgs.wl-clipboard}/bin/wl-paste --type image --watch cliphlist store"
      ];
      monitor =
        if (osConfig.networking.hostName == "desktop") then
          [
            "HDMI-A-1,preferred,-1080x-650,1,transform,1"
            "DP-1,preferred,0x0,1"
            "DVI-D-1,preferred,1920x0,1"
          ]
        else if (osConfig.networking.hostName == "laptop") then
          [ "eDP-1,preferred,auto,1" ]
        else
          [ ];
      workspace =
        if (osConfig.networking.hostName == "desktop") then
          [
            "HDMI-A-1,11"
            "DP-1,1"
            "DVI-D-1,21"

            "11,monitor:HDMI-A-1"
            "12,monitor:HDMI-A-1"
            "13,monitor:HDMI-A-1"
            "14,monitor:HDMI-A-1"
            "15,monitor:HDMI-A-1"
            "16,monitor:HDMI-A-1"
            "17,monitor:HDMI-A-1"
            "18,monitor:HDMI-A-1"
            "19,monitor:HDMI-A-1"
            "20,monitor:HDMI-A-1"

            "1,monitor:DP-1"
            "2,monitor:DP-1"
            "3,monitor:DP-1"
            "4,monitor:DP-1"
            "5,monitor:DP-1"
            "6,monitor:DP-1"
            "7,monitor:DP-1"
            "8,monitor:DP-1"
            "9,monitor:DP-1"
            "10,monitor:DP-1"

            "21,monitor:DVD-D-1"
            "22,monitor:DVD-D-1"
            "23,monitor:DVD-D-1"
            "24,monitor:DVD-D-1"
            "25,monitor:DVD-D-1"
            "26,monitor:DVD-D-1"
            "27,monitor:DVD-D-1"
            "28,monitor:DVD-D-1"
            "29,monitor:DVD-D-1"
            "30,monitor:DVD-D-1"
          ]
        else
          [ ];

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
        ", XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise --max-volume 120"
        ", XF86AudioLowerVolume, exec, swayosd-client --output-volume lower --max-volume 120"
        ", XF86MonBrightnessUp, exec, swayosd-client --brightness +10"
        ", XF86MonBrightnessDown, exec, swayosd-client --brightness -10"
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
        kb_layout = "fr";
        kb_options = "caps:swapescape";
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
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
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

        drop_shadow = "yes";
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";
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
      ];
    };
  };

  programs = {
    rofi = {
      enable = true;
      package = pkgs.rofi-wayland.override {
        rofi-unwrapped = pkgs.nur.repos.bhasherbel.rofi-wayland-unwrapped;
        plugins = [
          (pkgs.rofi-calc.override { rofi-unwrapped = pkgs.nur.repos.bhasherbel.rofi-wayland-unwrapped; })
          #pkgs.rofi-emoji
        ];
      };
      terminal = "kitty";
      theme = "~/.config/rofi/themes/type1-style8.rasi";
      extraConfig = {
        sorting-method = "alnum";
        sort = true;
      };
    };
    hyprlock = {
      enable = true;
      sourceFirst = true;
      settings = {
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
    waybar = {
      enable = true;
      systemd.enable = true;
      style = ./config/waybar/style.css;
      catppuccin = {
        enable = true;
        mode = "createLink";
      };
      settings = {
        topBar = {
          layer = "top";
          position = "top";
          height = 24;
          modules-left = [ "hyprland/workspaces" ];
          modules-center = [ "hyprland/window" ];
          modules-right = [
            "pulseaudio"
            "custom/kde-connect"
            "custom/VPN"
            "network"
            "custom/bandwidth"
            "cpu"
            "memory"
            "temperature"
            "battery"
            "clock"
            "tray"
            "custom/notifications"
          ];
          "hyprland/workspaces" = {
            disable-scroll = true;
            all-outputs = false;
            on-click = "activate";
            format = "{icon}";
            format-icons =
              if (osConfig.networking.hostName == "desktop") then
                {
                  "11" = "";
                  "12" = "2";
                  "13" = "3";
                  "14" = "4";
                  "15" = "5";
                  "16" = "6";
                  "17" = "7";
                  "18" = "8";
                  "19" = "9";
                  "20" = "0";
                  "1" = "";
                  "2" = "";
                  "3" = "3";
                  "4" = "4";
                  "5" = "5";
                  "6" = "6";
                  "7" = "7";
                  "8" = "8";
                  "9" = "9";
                  "10" = "0";
                  "21" = "";
                  "22" = "2";
                  "23" = "3";
                  "24" = "4";
                  "25" = "5";
                  "26" = "6";
                  "27" = "7";
                  "28" = "8";
                  "29" = "9";
                  "30" = "30";
                  urgent = "";
                  focused = "";
                  default = "";
                }
              else
                {
                  "1" = "";
                  "2" = "";
                  "3" = "";
                  "4" = "";
                  "5" = "5";
                  "6" = "6";
                  "7" = "7";
                  "8" = "8";
                  "9" = "9";
                  urgent = "";
                  focused = "";
                  default = "";
                };
          };
          tray = {
            spacing = 10;
          };
          clock = {
            format-alt = "{:%Y-%m-%d}";
          };
          cpu = {
            format = "{usage}% ";
          };
          memory = {
            format = "{}% ";
          };
          battery = {
            states = {
              warning = 20;
              critical = 10;
            };
            format = "{capacity}% {icon}";
            format-alt = "{time} {icon}";
            format-icons = [
              ""
              ""
              ""
              ""
              ""
            ];
          };
          network = {
            format-wifi = "{essid} ({signalStrength}%) ";
            format-ethernet = "{ifname}: {ipaddr}/{cidr} ";
            format-disconnected = "Disconnected ⚠";
          };
          temperature = {
            format = "{temperatureC}°C ";
          };
          "custom/bandwidth" = {
            exec = "$HOME/.config/waybar/scripts/bandwidth";
          };
          "custom/VPN" = {
            format = "{}";
            interval = 5;
            return-type = "json";
            exec = "$HOME/.config/waybar/scripts/vpn";
            on-click = "$HOME/.config/waybar/scripts/vpn-toggle";
          };
          pulseaudio = {
            format = "{volume}% {icon}";
            format-bluetooth = "{volume}% {icon}";
            format-muted = "";
            format-icons = {
              headphones = "";
              handsfree = "";
              headset = "";
              phone = "";
              portable = "";
              car = "";
              default = [
                ""
                ""
              ];
            };
            on-click = "pavucontrol";
          };
          "custom/notification" = {
            "tooltip" = false;
            "format" = "{icon}";
            "format-icons" = {
              notification = "<span foreground='red'><sup></sup></span>";
              none = "";
              dnd-notification = "<span foreground='red'><sup></sup></span>";
              dnd-none = "";
              inhibited-notification = "<span foreground='red'><sup></sup></span>";
              inhibited-none = "";
              dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
              dnd-inhibited-none = "";
            };
            return-type = "json";
            exec-if = "which swaync-client";
            exec = "swaync-client -swb";
            on-click = "swaync-client -t -sw";
            on-click-right = "swaync-client -d -sw";
            escape = true;
          };
        };
      };
    };
  };

  services = {
    swayosd.enable = true;
    swaync = {
      enable = true;
      settings = {
        positionX = "right";
        positionY = "bottom";
      };
    };
    udiskie = {
      enable = true;
      notify = true;
      automount = true;
    };
    hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
        };
        listener = [
          {
            timeout = 600;
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = 700;
            on-timeout = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
            on-resume = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
          }
          {
            timeout = 1200;
            on-timeout = "${pkgs.systemd}/bin/systemctl suspend";
          }
        ];
      };
    };
  };

  # Required for udiskie to works on Wayland
  # https://github.com/nix-community/home-manager/issues/2064
  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };

  home.file = {
    "${config.xdg.configHome}/assets" = {
      source = ./assets;
      recursive = true;
    };
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
        new=$(echo "$current - 0.25" | bc)

        wlr-randr --output eDP-1 --scale $new
      '';
      executable = true;
    };
    "${config.xdg.configHome}/swaync" = {
      source = ./config/swaync;
      recursive = true;
    };
    "${config.xdg.configHome}/rofi" = {
      source = ./config/rofi;
      recursive = true;
    };
    "${config.xdg.configHome}/waybar/scripts" = {
      source = ./config/waybar/scripts;
      recursive = true;
    };
  };
}
