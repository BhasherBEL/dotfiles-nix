{
  lib,
  config,
  pkgs,
  ...
}:
let
  activitywatchcfg = config.modules.activitywatch;
in
{
  options = {
    modules.activitywatch.enable = lib.mkEnableOption "Enable activitywatch";
  };

  config = lib.mkIf activitywatchcfg.enable {
    services.activitywatch = {
      enable = true;
      package = pkgs.aw-server-rust;
      watchers = {
        awatcher = {
          package = pkgs.awatcher;
          executable = "awatcher";
        };
      };
    };
  };
}
