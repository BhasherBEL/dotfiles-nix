{
  pkgs,
  lib,
  config,
  ...
}:
{
  services = {
    udev.packages = [ pkgs.yubikey-personalization ];
    pcscd.enable = true;
  };

  security.pam = {
    u2f = {
      enable = true;
      cue = true;
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
}
