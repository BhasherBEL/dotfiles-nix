{
  lib,
  modulesPath,
  ...
}:
{

  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [
        "size=6G"
        "mode=755"
      ];
    };
    "/home/shp" = {
      device = "none";
      fsType = "tmpfs";
      options = [
        "size=2G"
        "mode=777"
      ];
    };
    "/permadisk" = {
      device = "/dev/disk/by-uuid/7f5a267b-2cd6-4029-add4-01481760db0d";
      neededForBoot = true;
      fsType = "ext4";
      options = [ "noatime" ];
    };
    "/persistent" = {
      device = "/permadisk/persistent";
      neededForBoot = true;
      fsType = "none";
      options = [ "bind" ];
    };
    "/nix" = {
      device = "/permadisk/nix";
      fsType = "none";
      options = [ "bind" ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/9CE4-4D63";
      fsType = "vfat";
    };
  };

  networking.hostName = "shp";
  networking.networkmanager.enable = true;

  services = {
    openssh.enable = true;
    displayManager = {
      autoLogin = {
        enable = true;
        user = "spi";
      };
    };
  };

  environment.persistence."/persistent" = {
    enable = true;
    hideMounts = true;
    directories = [
      "/var/lib/nixos"
      "/etc/nixos"
      "/var/log"
      "/etc/NetworkManager/system-connections"
      "/var/lib/iwd"
      {
        directory = "/etc/ssh/";
        mode = "0700";
      }
      "/run/secrets.d"
    ];
  };

  system.stateVersion = "25.11";

  swapDevices = [ ];

  nixpkgs.hostPlatform = "x86_64-linux";

  users = {
    mutableUsers = false;
  };
}
