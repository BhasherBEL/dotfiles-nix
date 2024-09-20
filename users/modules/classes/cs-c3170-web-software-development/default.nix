{
  lib,
  config,
  pkgs,
  ...
}:
let
  cs-c3170-web-software-developmentcfg = config.modules.classes.cs-c3170-web-software-development;
in
{
  options = {
    modules.classes.cs-c3170-web-software-development.enable = lib.mkEnableOption "Enable cs-c3170-web-software-development";
  };

  config = lib.mkIf cs-c3170-web-software-developmentcfg.enable {
    environment.systemPackages = [ pkgs.deno ];
  };
}
