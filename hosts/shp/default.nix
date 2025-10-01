{
  lib,
  modulesPath,
  config,
  ...
}:
{

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./services.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };
    "/mnt/external" = {
      device = "/dev/sdb1";
      fsType = "ext4";
    };
  };

  networking = {
    hostName = "shp";
    networkmanager.enable = true;
    dhcpcd.enable = false;
    defaultGateway = "192.168.0.1";
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];
    interfaces.eno1 = {
      ipv4.addresses = [
        {
          address = "192.168.0.201";
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

  systemd.tmpfiles.rules = [
    "d /var/lib/private 0700 root root"
  ];

  system.activationScripts."createPersistentStorageDirs".deps = [
    "var-lib-private-permissions"
    "users"
    "groups"
  ];
  system.activationScripts = {
    "var-lib-private-permissions" = {
      deps = [ "specialfs" ];
      text = ''
        mkdir -p /persistent/var/lib/private
        chmod 0700 /persistent/var/lib/private
      '';
    };
  };

  system.stateVersion = "25.11";

  swapDevices = [ ];

  nixpkgs.hostPlatform = "x86_64-linux";

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  users = {
    mutableUsers = false;
  };
}
