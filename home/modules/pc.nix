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
      firefox.enable = true;
      catppuccin.enable = true;
      activitywatch.enable = true;
      hyprland.enable = true;
      hypridle.enable = true;
      hyprlock.enable = true;
      rofi.enable = true;
      swaync.enable = true;
      udiskie.enable = true;
      waybar.enable = true;
      kitty.enable = true;
    };
  };
}
