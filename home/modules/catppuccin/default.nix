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
  imports = [ inputs.catppuccin.homeModules.catppuccin ];

  options = {
    modules.catppuccin.enable = lib.mkEnableOption "Enable catppuccin";
  };

  config = lib.mkIf catppuccincfg.enable {

    #qt.platformTheme.name = lib.mkForce "kvantum";
    #qt.style.name = "kvantum";

    catppuccin = {
      enable = false;
      flavor = "latte"; # "macchiato";
      accent = "green";

      swaync.enable = false;
    };
  };
}
