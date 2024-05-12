{ pkgs, ... }:
{
  programs.openvpn3.enable = true;

  environment.systemPackages = with pkgs; [
    python311Packages.uvicorn
    sqlitebrowser
  ];
}
