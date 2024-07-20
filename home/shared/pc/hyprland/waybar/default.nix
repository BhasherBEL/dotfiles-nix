{ osConfig, config, ... }:
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ./style.css;
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

  home.file = {
    "${config.xdg.configHome}/waybar/scripts" = {
      source = ./scripts;
      recursive = true;
    };
  };
}
