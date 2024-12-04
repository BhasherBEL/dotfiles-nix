{
  pkgs,
  lib,
  config,
  ...
}:
let
  rustdeskcfg = config.modules.rustdesk;
in
{
  options = {
    modules.rustdesk.enable = lib.mkEnableOption "Enable rustdesk";
  };

  config = lib.mkIf rustdeskcfg.enable {
    environment.systemPackages = with pkgs; [ rustdesk ];

    nixpkgs.config.allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        # Rustdesk require this unfree package to work
        "libsciter"
      ];
  };
}
