{ lib, config, ... }:
let
  dockercfg = config.modules.docker;

  daemon-settings = {
    dns = [
      "1.1.1.1"
      "1.0.0.1"
    ];
  };
in
{
  options = {
    modules.docker.enable = lib.mkEnableOption "Enable docker";
  };

  config = lib.mkIf dockercfg.enable {
    virtualisation.docker = {
      enable = true;
      enableOnBoot = false;
      daemon.settings = daemon-settings;
      autoPrune = {
        enable = true;
        flags = [ "--all" ];
      };
      rootless = {
        enable = true;
        setSocketVariable = true;
        daemon.settings = daemon-settings;
      };
    };
  };
}
