{
  lib,
  config,
  inputs,
  ...
}:
let
  catppuccincfg = config.modules.catppuccin;
in
{
  imports = [ inputs.catppuccin.homeManagerModules.catppuccin ];

  options = {
    modules.catppuccin.enable = lib.mkEnableOption "Enable catppuccin";
  };

  config = lib.mkIf catppuccincfg.enable {
    catppuccin = {
      flavor = "macchiato";
      accent = "green";
    };
  };
}
