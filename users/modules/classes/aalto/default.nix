{
  lib,
  config,
  pkgs,
  ...
}:
let
  aaltocfg = config.modules.classes.aalto;
in
{
  options = {
    modules.classes.aalto.enable = lib.mkEnableOption "Enable aalto";
  };

  config = lib.mkIf aaltocfg.enable {
    environment.systemPackages = [ pkgs.openconnect ];
  };
}
