{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    python3
    virtualenv
    black
    nodePackages.pyright
  ];
}
