{ lib, config, ... }:
let
  udiskiecfg = config.modules.udiskie;
in
{
  options = {
    modules.udiskie.enable = lib.mkEnableOption "Enable udiskie";
  };

  config = lib.mkIf udiskiecfg.enable {
    services.udiskie = {
      enable = true;
      notify = true;
      automount = false;
    };

    # Required for udiskie to works on Wayland
    # https://github.com/nix-community/home-manager/issues/2064
    systemd.user.targets.tray = {
      Unit = {
        Description = "Home Manager System Tray";
        Requires = [ "graphical-session-pre.target" ];
      };
    };

  };
}
