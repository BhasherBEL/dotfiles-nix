{
  lib,
  config,
  pkgs,
  ...
}:
let
  sudocfg = config.hostModules.sudo;
in
{
  options = {
    hostModules.sudo = {
      enable = lib.mkEnableOption "Enable sudo";
      powerCommands = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable extra sudo rules for systemctl suspend, reboot, and poweroff without password";
      };
    };
  };

  config = lib.mkIf sudocfg.enable {
    security.sudo = {
      enable = true;
      extraRules = lib.optional sudocfg.powerCommands {
        commands = [
          {
            command = "${pkgs.systemd}/bin/systemctl suspend";
            options = [ "NOPASSWD" ];
          }
          {
            command = "${pkgs.systemd}/bin/reboot";
            options = [ "NOPASSWD" ];
          }
          {
            command = "${pkgs.systemd}/bin/poweroff";
            options = [ "NOPASSWD" ];
          }
        ];
      };
    };
  };
}
