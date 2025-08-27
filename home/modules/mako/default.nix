{ lib, config, ... }:
let
  makocfg = config.modules.mako;
in
{
  options = {
    modules.mako.enable = lib.mkEnableOption "Enable mako";
  };

  config = lib.mkIf makocfg.enable {

    services.mako = {
      enable = true;
    };
  };
}
