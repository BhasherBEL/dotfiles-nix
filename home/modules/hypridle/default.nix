{
  lib,
  config,
  pkgs,
  ...
}:
let
  hypridlecfg = config.modules.hypridle;
in
{
  options = {
    modules.hypridle.enable = lib.mkEnableOption "Enable hypridle";
  };

  config = lib.mkIf hypridlecfg.enable {
    services.hypridle = rec {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
          #before_sleep_cmd = "loginctl lock-session";
          before_sleep_cmd = settings.general.lock_cmd;
          after_sleep_cmd = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
        };
        listener = [
          {
            timeout = 600;
            #on-timeout = "loginctl lock-session";
            on-timeout = settings.general.lock_cmd;
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
}
