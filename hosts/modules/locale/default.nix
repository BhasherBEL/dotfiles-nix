{ lib, config, ... }:
let
  localecfg = config.hostModules.locale;
in
{
  options = {
    hostModules.locale.enable = lib.mkEnableOption "Enable locale";
  };

  config = lib.mkIf localecfg.enable {
    i18n = {
      supportedLocales = [
        "fr_FR.UTF-8/UTF-8"
        "en_GB.UTF-8/UTF-8"
      ];
      defaultLocale = "en_GB.UTF-8";
      extraLocaleSettings = {
        LC_NUMERIC = "fr_FR.UTF-8";
        LC_MONETARY = "fr_FR.UTF-8";
      };
    };

    console.keyMap = "fr";
  };
}
