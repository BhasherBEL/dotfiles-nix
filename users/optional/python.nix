{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    black
    pyright
    (python312.withPackages (
      ps: with ps; [
        numpy
        pandas
        matplotlib
        jupyter
        scapy
        virtualenv
      ]
    ))
  ];
}
