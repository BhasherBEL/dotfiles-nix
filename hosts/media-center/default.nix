{
  lib,
  modulesPath,
  pkgs,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    kernelParams = [
      "snd_bcm2835.enable_hdmi=1"
      "snd_bcm2835.enable_headphones=1"
    ];
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
        "size=4G"
        "mode=755"
      ];
    };
    "/home/kodi" = {
      device = "none";
      fsType = "tmpfs";
      options = [
        "size=4G"
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
    # "/boot" = {
    #   device = "/dev/disk/by-label/FIRMWARE";
    #   fsType = "vfat";
    #   options = [ "fmask=0022" "dmask=0022" ];
    #   neededForBoot = true;
    # };
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
  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
  ];

  networking.hostName = "media-center";
  networking.networkmanager.enable = true;

  services = {
    openssh.enable = true;
    displayManager = {
      autoLogin = {
        enable = true;
        user = "kodi";
      };
    };
    xserver = {
      enable = true;
      desktopManager.kodi = {
        enable = true;
        package = pkgs.kodi.withPackages (
          p: with p; [
            jellyfin
            # netflix
            # invidious
            arteplussept
            sponsorblock
            inputstreamhelper
            youtube
          ]

        );
      };
      displayManager.lightdm.enable = true;
    };
  };

  security.sudo.extraConfig = "Defaults lecture=never";
  environment.persistence."/persistent" = {
    enable = true;
    hideMounts = true;
    directories = [
      "/etc/nixos"
      "/var/lib"
      "/var/log"
      #To prevent builds to fill all remaining space
      "/tmp"
      "/var/tmp"
      {
        directory = "/etc/ssh/";
        mode = "0700";
      }
      "/run/secrets.d"
    ];
    files = [
      #"/etc/machine-id"
    ];
    users.kodi = {
      directories = [ ".kodi" ];
      # files = [ ".zsh_history" ];
    };
  };

  system.stateVersion = "25.11";

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  users = {
    mutableUsers = false;
  };
}
