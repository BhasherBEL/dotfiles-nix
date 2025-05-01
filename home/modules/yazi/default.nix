{
  lib,
  config,
  pkgs,
  ...
}:
let
  yazicfg = config.modules.yazi;
in
{
  options = {
    modules.yazi.enable = lib.mkEnableOption "Enable yazi";
  };

  config = lib.mkIf yazicfg.enable {
    home.packages = with pkgs; [ ueberzugpp ];

    programs.yazi = {
      enable = true;
      plugins = {
        office = pkgs.fetchFromGitHub {
          owner = "macydnah";
          repo = "office.yazi";
          rev = "d1e3e51857c109fbfc707ab0f9f383dc98b9795f";
          sha256 = "sha256-ORcexu1f7hb7G4IyzQIfGlCkH3OWlk4w5FtZrbXkR40=";
        };
      };
    };
  };
}
