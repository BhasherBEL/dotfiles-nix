{ lib, config, ... }:
let
  dockercfg = config.modules.docker;
in
{
  options = {
    modules.docker.enable = lib.mkEnableOption "Enable docker";
  };

  config = lib.mkIf dockercfg.enable {
    virtualisation.docker = {
      enable = true;
      enableOnBoot = false;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  };
}
