{
  lib,
  config,
  pkgs,
  ...
}:
let
  yubikeycfg = config.modules.yubikey;
in
{
  options = {
    modules.yubikey.enable = lib.mkEnableOption "Enable yubikey";
  };

  config = lib.mkIf yubikeycfg.enable {
    environment.systemPackages = with pkgs; [
      yubikey-manager
      pam_u2f
    ];

    services = {
      udev.packages = [ pkgs.yubikey-personalization ];
      pcscd.enable = true;
    };

    security.pam = {
      u2f = {
        enable = true;
        settings.cue = true;
      };
      # https://github.com/swaywm/swaylock/issues/61
      services.swaylock = {
        u2fAuth = true;
        rules.auth.u2f = {
          order = config.security.pam.services.login.rules.auth.unix.order + 10;
          args = lib.mkAfter [
            "pinverification=0"
            "userverification=1"
          ];
        };
      };
    };
  };
}
