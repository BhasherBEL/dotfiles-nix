{ pkgs, ... }:
{
  home.username = "shp";
  home.homeDirectory = "/home/shp";

  home.stateVersion = "25.05";
  
  imports = [ ./modules ];

  modules = {
    ssh.enable = false;
  };
}
