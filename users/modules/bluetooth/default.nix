{ lib, config, ... }:
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
    };
  };
}
