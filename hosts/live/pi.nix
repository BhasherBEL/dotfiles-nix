{ lib, modulesPath, ... }:
let
  user = "nixos";
in
{
  imports = [
    # (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
    # (modulesPath + "/installer/cd-dvd/channel.nix")
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.loader = {
    grub.enable = false;
    generic-extlinux-compatible.enable = true;
  };

  programs.command-not-found.enable = true;

  networking = {
    hostName = user;
    # networkmanager.enable = lib.mkForce false;
    useDHCP = lib.mkForce true;
  };

  system.stateVersion = "25.11";

  nix.settings.trusted-users = [ user ];

  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "nixos";
  };

  services = {
    openssh.enable = true;
    displayManager = {
      autoLogin = {
        enable = true;
        user = user;
      };
    };
  };

  home-manager.users.${user} = {
    imports = [ ../../home/modules ];
    home = {
      username = user;
      homeDirectory = "/home/${user}";
      stateVersion = "25.11";
    };

    modules = {
      kitty.enable = false;
    };
  };

  nixpkgs.hostPlatform = "aarch64-linux";

  hardware.raspberry-pi."4" = {
    dwc2.enable = true;
  };

  overlays = [
    (final: super: {
      makeModulesClosure = x: super.makeModulesClosure (x // { allowMissing = true; });
    })
  ];
}
