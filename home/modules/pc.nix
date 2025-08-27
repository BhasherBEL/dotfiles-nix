{
  lib,
  config,
  ...
}:
let
  metapccfg = config.modules.metaPc;
in
{
  options = {
    modules.metaPc = {
      enable = lib.mkEnableOption "Enable meta module PC";
      monitors = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "Amount of monitors";
        default = [ ];
      };
    };
  };

  config = lib.mkIf metapccfg.enable {
    services = {
      swayosd.enable = true;
    };

    modules = {
      firefox.enable = lib.mkDefault true;
      catppuccin.enable = lib.mkDefault true;
      activitywatch.enable = lib.mkDefault true;
      hyprland.enable = lib.mkDefault true;
      hypridle.enable = lib.mkDefault true;
      hyprlock.enable = lib.mkDefault true;
      rofi.enable = lib.mkDefault true;
      swaync.enable = lib.mkDefault false;
      udiskie.enable = lib.mkDefault true;
      waybar.enable = lib.mkDefault true;
      alacritty.enable = lib.mkDefault true;
    };
  };
}
