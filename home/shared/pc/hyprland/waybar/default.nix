{ osConfig, config, ... }:
let
  defaultBar = {
    layer = "top";
    position = "top";
    "hyprland/workspaces" = {
      disable-scroll = true;
      all-outputs = false;
      on-click = "activate";
      window-rewrite = {
        "class<firefox>" = "";
        "class<freetube>" = "";
        "class<kitteh>" = "";
      };
      "persistent-workspaces" = {
        "*" = 10;
      };
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
            "30" = "0";
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
            "10" = "0";
            urgent = "";
            focused = "";
            default = "";
          };
    };
    tray = {
      spacing = 10;
    };
    clock = {
      format = "{:%H:%M | %a • %h | %d-%m-%Y}";
      format-alt = "{:%H:%M}";
      tooltip-format = "<tt><small>{calendar}</small></tt>";
    };
    cpu = {
      format = "{usage}% ";
    };
    memory = {
      format = "{}% ";
    };
    disk = {
      format = "{percentage_used}% ";
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
      format-wifi = "{bandwidthUpOctets}/{bandwidthDownOctets}  ";
      format-ethernet = "{bandwidthUpOctets}/{bandwidthDownOctets}  ";
      format-disconnected = "⚠";
      tooltip-format-wifi = "{essid} ({frequency}, {signalStrength}%)";
      tooltip-format-ethernet = "{ifname}: {ipaddr}/{cidr}";
      tooltip-format-disconnected = "Disconnected";
      interval = 1;
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
in
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ./style.css;
    catppuccin = {
      enable = true;
      mode = "createLink";
    };
    settings =
      if (osConfig.networking.hostName == "desktop") then
        {
          mainBar = defaultBar // {
            output = [ "DP-1" ];
            modules-left = [ "hyprland/workspaces" ];
            modules-center = [ "clock" ];
            modules-right = [
              #"custom/kde-connect"
              "custom/VPN"
              "network"
              "custom/bandwidth"
              "tray"
              "custom/notifications"
            ];
          };
          rightBar = defaultBar // {
            output = [ "DVI-D-1" ];
            modules-left = [ "hyprland/workspaces" ];
            modules-right = [
              "pulseaudio"
              "privacy"
            ];
          };
          leftBar = defaultBar // {
            output = [ "HDMI-A-1" ];
            modules-left = [ "hyprland/workspaces" ];
            modules-right = [
              "cpu"
              "memory"
              "temperature"
              "disk"
              "battery"
            ];
          };
        }
      else
        {
          uniqueBar = defaultBar // {
            modules-left = [ "hyprland/workspaces" ];
            modules-center = [ "clock" ];
            modules-right = [
              "network"
              "custom/VPN"
              "privacy"
              "cpu"
              "memory"
              "temperature"
              "disk"
              "pulseaudio"
              "battery"
              "tray"
              "custom/notifications"
            ];
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
