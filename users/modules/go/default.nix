{
  pkgs,
  lib,
  config,
  ...
}:
let
  gocfg = config.modules.go;
in
{
  options = {
    modules.go.enable = lib.mkEnableOption "Enable go";
  };

  config = lib.mkIf gocfg.enable {
    environment.systemPackages = with pkgs; [
      go
      gopls
    ];
  };
}
