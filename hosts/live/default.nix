{ lib, modulesPath, ... }:
let
  user = "nixos";
in
{
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
    (modulesPath + "/installer/cd-dvd/channel.nix")
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  programs.command-not-found.enable = true;

  networking.networkmanager.enable = lib.mkForce false;

  system.stateVersion = "25.05";

  nix.settings.trusted-users = [ user ];

  users.users.${user} = {
    isNormalUser = true;
  };

  home-manager.users.${user} = {
    imports = [ ../../home/modules ];
    home = {
      username = user;
      homeDirectory = "/home/${user}";
      stateVersion = "25.05";
    };

    modules = {
      kitty.enable = false;
    };
  };
}
