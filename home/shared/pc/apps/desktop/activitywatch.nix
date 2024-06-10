{ pkgs, ... }:
{

  services.activitywatch = {
    enable = true;
    package = pkgs.aw-server-rust;
    watchers = {
      aw-awatcher = {
        package = pkgs.nur.repos.bhasherbel.aw-awatcher;
        executable = "awatcher";
      };
    };
  };
}
