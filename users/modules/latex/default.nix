{
  pkgs,
  lib,
  config,
  ...
}:
let
  latexcfg = config.modules.latex;
in
{
  options = {
    modules.latex.enable = lib.mkEnableOption "Enable latex";
  };

  config = lib.mkIf latexcfg.enable {
    environment.systemPackages = with pkgs; [
      (texlive.combine {
        inherit (texlive) scheme-basic;
      })
    ];
  };
}
