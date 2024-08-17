{
  lib,
  config,
  pkgs,
  ...
}:
let
  kittycfg = config.modules.kitty;
in
{
  options = {
    modules.kitty.enable = lib.mkEnableOption "Enable kitty";
  };

  config = lib.mkIf kittycfg.enable {
    programs.kitty = {
      enable = true;
      shellIntegration.enableZshIntegration = true;
      settings.confirm_os_window_close = -1;
      font = {
        name = "Hack Nerd Font Mono";
        package = pkgs.nerdfonts.override {
          fonts = [
            "FiraCode"
            "DroidSansMono"
            "Hack"
          ];
        };
      };
      theme = lib.mkDefault "Catppuccin-Macchiato";
    };
  };
}
