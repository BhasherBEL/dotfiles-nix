{ pkgs, ... }: {
  imports = [
    ../../optional/python.nix
    ../../optional/languagelab.nix
    ../../optional/docker.nix
  ];

  home-manager.users.bhasher = import ../../../../home/bhasher.nix;

  users.users.bhasher = {
    isNormalUser = true;
    initialPassword = "azerty";
    extraGroups = [ "wheel" "audio" "docker" ];
  };

  environment.systemPackages = with pkgs; [ tree ];
}
