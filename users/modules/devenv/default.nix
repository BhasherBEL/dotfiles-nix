{
  lib,
  config,
  pkgs,
  ...
}:
let
  devenvcfg = config.modules.devenv;
in
{
  options = {
    modules.devenv.enable = lib.mkEnableOption "Enable devenv";
  };

  config = lib.mkIf devenvcfg.enable {
    environment.systemPackages = with pkgs; [
      devenv
    ];

    programs.direnv = {
      enable = false;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

  };
}
