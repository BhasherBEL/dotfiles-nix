{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    black
    nodePackages.pyright
    (python311.withPackages (
      ps: with ps; [
        numpy
        pandas
        matplotlib
        jupyter
        scapy
      ]
    ))
  ];
}
