{
  lib,
  config,
  pkgs,
  ...
}:
let
  fluttercfg = config.modules.flutter;
  buildToolsVersion = "34.0.0";
  androidComposition = pkgs.androidenv.composeAndroidPackages {
    buildToolsVersions = [
      buildToolsVersion
      "28.0.3"
    ];
    platformVersions = [
      "34"
      "28"
    ];
    abiVersions = [
      "armeabi-v7a"
      "arm64-v8a"
    ];
  };

  androidSdk = androidComposition.androidsdk;
in
{
  options = {
    modules.flutter.enable = lib.mkEnableOption "Enable flutter";
  };

  config = lib.mkIf fluttercfg.enable {

    nixpkgs.config.android_sdk.accept_license = true;

    environment.variables = {
      ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";
    };

    programs.adb.enable = true;

    environment.systemPackages = with pkgs; [
      flutter
      androidSdk
      jdk17
    ];
  };
}
