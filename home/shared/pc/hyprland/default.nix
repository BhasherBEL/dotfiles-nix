{
  pkgs,
  config,
  osConfig,
  ...
}:
{
  programs = {
    waybar = {
      enable = true;
      settings = {
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
          "battery"
          "tray"
          "custom/notifications"
          "clock"
        ];
        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = false;
          on-click = "activate";
          format = "{icon}";
          format-icons = {
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
        "custom/kde-connect" = {
          format = "{}";
          interval = 10;
          return-type = "json";
          exec = "$HOME/.config/waybar/scripts/kde-connect";
        };
        "custom/notification" = {
          tooltip = false;
          format = "{icon}";
          format-icons = {
            notification = "<span foreground='red'><sup></sup></span>";
            none = "";
            "dnd-notification" = "<span foreground='red'><sup></sup></span>";
            "dnd-none" = "";
            "inhibited-notification" = "<span foreground='red'><sup></sup></span>";
            "inhibited-none" = "";
            "dnd-inhibited-notification" = "<span foreground='red'><sup></sup></span>";
            "dnd-inhibited-none" = "";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
          escape = true;
        };
      };
      style = ''
        * {
        	border: none;
        	border-radius: 0;
        	font-family: "Ubuntu Nerd Font";
        	font-size: 13px;
        	min-height: 0;
        }

        window#waybar {
        	background: transparent;
        	color: white;
        }

        #window {
        	font-weight: bold;
        	font-family: "Ubuntu";
        }
        /*
        #workspaces {
        		padding: 0 5px;
        }
        */

        #workspaces button {
        	padding: 0 5px;
        	background: transparent;
        	color: white;
        	border-top: 2px solid transparent;
        }

        #workspaces button.active {
        	color: #f88;
        	border: 1px solid #f88;
        	border-radius: 5px;
        }

        #mode {
        	background: #64727d;
        	border-bottom: 3px solid white;
        }

        #clock,
        #battery,
        #cpu,
        #memory,
        #network,
        #pulseaudio,
        #custom-spotify,
        #tray,
        #mode,
        #custom-VPN,
        #custom-bandwidth,
        #custom-kde-connect {
        	padding: 0 3px;
        	margin: 0 2px;
        	border-left: 1px solid #777;
        }

        #clock {
        	font-weight: bold;
        }

        #battery icon {
        	color: red;
        }

        #battery.charging {
        	color: orange;
        }

        @keyframes blink {
        	to {
        		background-color: #ffffff;
        		color: black;
        	}
        }

        #battery.warning:not(.charging) {
        	color: white;
        	animation-name: blink;
        	animation-duration: 0.5s;
        	animation-timing-function: linear;
        	animation-iteration-count: infinite;
        	animation-direction: alternate;
        }

        #custom-VPN {
        	/*padding: 5px 10px;*/
        }

        #custom-VPN.down,
        #network.disconnected {
        	border-radius: 5px;
        	background-color: #f33;
        }

        #custom-kde-connect.down {
        	color: darkred;
        }
      '';
    };
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
    hyprlock.enable = true;
  };

  services = {
    hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock";
          unlock_cmd = "killall -s SIGUSR1 hyprlock";
          before_sleep_cmd = "playerctl pause ; loginctl lock-session";
          after_wake_cmd = "hyprctl dispatch dpms on";
          ignore_dbus_inhibit = false;
        };
        listener = [
          {
            timeout = 150;
            on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0";
            on-resume = "brightnessctl -rd rgb:kbd_backlight";
          }
          {
            timeout = 240;
            on-timeout = "brightnessctl -s set 10";
            on-resume = "brightnessctl -r";
          }
          {
            timeout = 300;
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = 330;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
          {
            timeout = 600;
            on-timeout = "loginctl lock-session ; systemctl suspend-then-hibernate";
          }
        ];
      };
    };
  };

  home.file = {
    "${config.xdg.configHome}/hypr/src" = {
      source = ./config/hypr/src;
      recursive = true;
    };
    "${config.xdg.configHome}/hypr/themes" = {
      source = ./config/hypr/themes;
      recursive = true;
    };
    "${config.xdg.configHome}/hypr/scripts" = {
      source = ./config/hypr/scripts;
      recursive = true;
      executable = true;
    };
    "${config.xdg.configHome}/hypr/hyprlock.conf" = {
      source = ./config/hypr/hyprlock.conf;
    };
    "${config.xdg.configHome}/hypr/autostart" = {
      source = ./config/hypr/autostart;
    };
    "${config.xdg.configHome}/hypr/hyprland.conf" = {
      source =
        if (osConfig.networking.hostName == "desktop") then
          ./config/hypr/hyprland-desktop.conf
        else if (osConfig.networking.hostName == "laptop") then
          ./config/hypr/hyprland-laptop.conf
        else
          ./config/hypr/hyprland-generic.conf;
    };
    "${config.xdg.configHome}/hypr/hyprland-generic.conf" = {
      source = ./config/hypr/hyprland-generic.conf;
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
