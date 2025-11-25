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
        "size=2G"
        "mode=755"
      ];
    };
    "/home/spi" = {
      device = "none";
      fsType = "tmpfs";
      options = [
        "size=500M"
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

  networking = {
    hostName = "spi";
    networkmanager.enable = true;
    dhcpcd.enable = false;
    defaultGateway = "192.168.1.1";
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];
    interfaces.end0 = {
      ipv4.addresses = [
        {
          address = "192.168.1.200";
          prefixLength = 24;
        }
      ];
    };
  };

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

  nix.settings = {
    cores = 1;
    max-jobs = 1;
  };

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  users = {
    mutableUsers = false;
  };

  hostServices = {
    dyndns.bxl.enable = true;
    # dns.enable = true;
    vpn-client = {
      enable = true;
      ipv4 = "10.20.0.5/24";
      ipv6 = "fd8c:70ee:bdd8:2:1::1/128";
      privateKeySecret = "wg/bxl-shp/spi/key";
      route.wol = true;
      autostart = true;
    };
  };
}
