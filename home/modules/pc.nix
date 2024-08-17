{
  lib,
  config,
  osConfig,
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
        type = lib.types.int;
        description = "Amount of monitors";
        default = if osConfig.networking.hostName == "desktop" then 3 else 1;
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
