{ lib, config, ... }:
let
  metapccfg = config.modules.metaPc;
in
{

  options = {
    modules.metaPc.enable = lib.mkEnableOption "Enable meta module PC";
  };

  config = lib.mkIf metapccfg.enable {
    modules = {
      yubikey.enable = lib.mkDefault true;
      theming.enable = lib.mkDefault true;
    };
  };
}
