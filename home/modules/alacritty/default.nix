{ lib, config, ... }:
let
  alacrittycfg = config.modules.alacritty;
in
{
  options = {
    modules.alacritty.enable = lib.mkEnableOption "Enable alacritty";
  };

  config = lib.mkIf alacrittycfg.enable {
    programs.alacritty = {
      enable = true;
      settings = {
        window.padding = {
          x = 2;
          y = 2;
        };
      };
    };
  };
}
