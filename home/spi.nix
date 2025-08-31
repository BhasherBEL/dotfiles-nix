{ pkgs, ... }:
{
  home.username = "spi";
  home.homeDirectory = "/home/spi";

  home.stateVersion = "25.11";

  imports = [ ./modules ];
}
