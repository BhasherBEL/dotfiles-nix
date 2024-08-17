{ config, lib, ... }:
let
  kdeconnectcfg = config.modules.kdeconnect;
in
{
  options = {
    modules.kdeconnect.enable = lib.mkEnableOption "Enable kdeconnect";
  };

  config = lib.mkIf kdeconnectcfg.enable {
    # TODO: Make it works 🙃
    services.kdeconnect = {
      enable = true;
      indicator = true;
    };
  };
}
