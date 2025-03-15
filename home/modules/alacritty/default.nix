{
  lib,
  config,
  pkgs,
  ...
}:
let
  alacrittycfg = config.modules.alacritty;
in
{
  options = {
    modules.alacritty.enable = lib.mkEnableOption "Enable alacritty";
  };

  config = lib.mkIf alacrittycfg.enable {

    fonts.fontconfig.enable = true;

    home.packages = [
      pkgs.nerd-fonts.fira-code
    ];

    programs.alacritty = {
      enable = true;
      settings = {
        window.padding = {
          x = 2;
          y = 2;
        };
        font = {
          normal = {
            family = lib.mkForce "Fira Code Nerd Font";
            style = "Regular";
          };
          bold = {
            family = lib.mkForce "Fira Code Nerd Font";
            style = "Bold";
          };
          italic = {
            family = lib.mkForce "Fira Code Nerd Font";
            style = "Italic";
          };
        };
      };
    };
  };
}
