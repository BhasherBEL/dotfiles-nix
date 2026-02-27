{ ... }:
{
  home.username = "snc";
  home.homeDirectory = "/home/snc";

  home.stateVersion = "25.11";

  imports = [ ./modules ];

  modules = {
    nvim = {
      headless = true;
    };
  };
}
