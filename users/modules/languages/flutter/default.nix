{
  lib,
  config,
  ...
}:
let
  fluttercfg = config.modules.languages.flutter;
in
{
  options = {
    modules.languages.flutter.enable = lib.mkEnableOption "Enable flutter";
  };

  config = lib.mkIf fluttercfg.enable {
    nixpkgs.config.android_sdk.accept_license = true;

    programs.adb.enable = true;
  };
}
