{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    vscodium-fhs
    sqlitebrowser
  ];
}
