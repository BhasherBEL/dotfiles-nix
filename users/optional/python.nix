{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    black
    pyright
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
