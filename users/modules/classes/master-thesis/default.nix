{
  lib,
  config,
  pkgs,
  ...
}:
let
  master-thesiscfg = config.modules.classes.master-thesis;
in
{
  options = {
    modules.classes.master-thesis.enable = lib.mkEnableOption "Enable master-thesis";
  };

  config = lib.mkIf master-thesiscfg.enable {
    environment.systemPackages = with pkgs; [
      zotero
    ];
  };
}
