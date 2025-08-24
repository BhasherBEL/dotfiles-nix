{
  lib,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "usbhid"
      ];
      kernelModules = [ ];
    };
    kernelModules = [ ];
    extraModulePackages = [ ];
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };

  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [
        "size=3G"
        "mode=755"
      ];
    };
    "/home/shp" = {
      device = "none";
      fsType = "tmpfs";
      options = [
        "size=1G"
        "mode=777"
      ];
    };
    "/sd-card" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      neededForBoot = true;
      fsType = "ext4";
      options = [ "noatime" ];
    };
    "/persistent" = {
      device = "/sd-card/persistent";
      neededForBoot = true;
      fsType = "none";
      options = [ "bind" ];
    };
    "/nix" = {
      device = "/sd-card/nix";
      fsType = "none";
      options = [ "bind" ];
    };
    "/boot" = {
      device = "/sd-card/boot";
      fsType = "none";
      options = [ "bind" ];
    };
  };

  hardware = {
    raspberry-pi."4" = {
      apply-overlays-dtmerge.enable = true;
      fkms-3d.enable = true;
      bluetooth.enable = true;
    };
    deviceTree.enable = true;
    bluetooth.enable = true;
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

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  users = {
    mutableUsers = false;
  };
}
