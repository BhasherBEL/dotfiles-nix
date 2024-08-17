{ config, lib, ... }:
let
  syncthingcfg = config.modules.syncthing;
in
{
  options = {
    modules.syncthing.enable = lib.mkEnableOption "Enable syncthing";
  };

  config = lib.mkIf syncthingcfg.enable {
    # TODO: Increase declarativeness
    services.syncthing = {
      enable = true;
    };
  };
}
