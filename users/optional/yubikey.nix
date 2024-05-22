{ pkgs, lib, ... }:
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
    services.swaylock = {
      u2fAuth = true;
      rules.auth.u2f.args = lib.mkAfter [
        "pinverification=0"
        "userverification=1"
      ];
    };
  };
}
