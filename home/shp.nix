{ pkgs, ... }:
{
  home.username = "shp";
  home.homeDirectory = "/home/shp";

  home.stateVersion = "25.05";

  imports = [ ./modules ];

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  sops = {
    defaultSopsFile = ./../secrets/bhasher.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/etc/nixos/keys/bhasher.txt";
    secrets = {
      "ssh/gitkey" = {
        path = "/run/secrets/ssh/gitkey";
      };
    };
  };

  home = {
    packages = with pkgs; [ python3 ];
  };
}
