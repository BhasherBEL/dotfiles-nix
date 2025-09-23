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
      device = "/dev/disk/by-label/NIXOS_DISK";
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
      device = "/permadisk/boot";
      fsType = "none";
      options = [ "bind" ];
    };
  };

  networking.hostName = "shp";
  networking.networkmanager.enable = true;
  networking.useDHCP = true;

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
