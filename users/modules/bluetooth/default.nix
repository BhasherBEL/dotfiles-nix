{
  lib,
  config,
  pkgs,
  ...
}:
let
  bluetoothcfg = config.modules.bluetooth;
in
{
  options = {
    modules.bluetooth.enable = lib.mkEnableOption "Enable bluetooth";
  };

  config = lib.mkIf bluetoothcfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      package = pkgs.bluez;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          Experimental = true;
        };
      };
    };

    services.blueman.enable = true;

    systemd.services.bluetooth-power-on = {
      description = "Power on Bluetooth adapter and unblock rfkill";
      after = [ "bluetooth.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = [
          "${pkgs.util-linux}/bin/rfkill unblock bluetooth"
          "${pkgs.bluez}/bin/bluetoothctl power on"
        ];
      };
    };
  };
}
