{
  pkgs,
  lib,
  config,
  ...
}:
let
  pythoncfg = config.modules.python;
in
{
  options = {
    modules.python.enable = lib.mkEnableOption "Enable python";
  };

  config = lib.mkIf pythoncfg.enable {
    environment.systemPackages = with pkgs; [
      black
      pyright
      (python3.withPackages (
        ps:
        with ps;
        [
          numpy
          pandas
          matplotlib
          seaborn
          jupyter
          scapy
          virtualenv
          pyserial # arduino
        ]
        ++ lib.optional config.modules.classes.master-thesis.enable [
          pyserial # arduino
          scipy
        ]
      ))
    ];
  };
}
