{
  lib,
  modulesPath,
  pkgs,
  config,
  inputs,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    kernelParams = [
      # "snd_bcm2835.enable_headphones=1" # Avoid the jacks to become the default
      "cma=252M"
    ];
    initrd = {
      systemd.tpm2.enable = false; # Not present on raspberry-pi 4
      availableKernelModules = [
        "xhci_pci"
        "usbhid"
      ];
      kernelModules = [ ];
    };
    kernelPackages =
      inputs.nixos-raspberrypi.packages.${pkgs.stdenv.hostPlatform.system}.linuxPackages_rpi4;
    kernelModules = [ ];
    kernel.sysctl."vm.mmap_rnd_bits" = 18;
    extraModulePackages = [ ];
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };

  services.xserver.xrandrHeads = [
    {
      output = "HDMI-1";
      primary = true;
      monitorConfig = ''Option "PreferredMode" "1920x1080"'';
    }
  ];

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
      neededForBoot = true;
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
    "/boot" = {
      device = "/sd-card/boot";
      fsType = "none";
      options = [ "bind" ];
    };
  };

  hardware = {
    deviceTree = {
      enable = true;
      filter = "bcm2711-rpi-4*.dtb";
      overlays = [
        {
          name = "vc4-kms-v3d-pi4";
          dtboFile = "${config.boot.kernelPackages.kernel}/dtbs/overlays/vc4-kms-v3d-pi4.dtbo";
        }
      ];
    };
    bluetooth.enable = true;
  };

  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
    libcec
    libdrm.bin # debug
  ];

  services.udev.extraRules = ''
    KERNEL=="vchiq", GROUP="video", MODE="0660", TAG+="systemd", ENV{SYSTEMD_ALIAS}="/dev/vchiq"
  '';

  networking = {
    hostName = "media-center";
    networkmanager.enable = true;
    dhcpcd.enable = false;
    defaultGateway = "192.168.0.1";
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];
    interfaces.end0.ipv4.addresses = [
      {
        address = "192.168.0.200";
        prefixLength = 24;
      }
    ];
  };

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
            pkgs.libcec
            jellyfin
            arteplussept
            sendtokodi
            inputstreamhelper
            sponsorblock
            youtube
            (pkgs.kodiPackages.callPackage ./custom-addons/bluetooth-manager { })
            (pkgs.kodiPackages.callPackage ./custom-addons/navidrome { })
          ]
        );
      };
      displayManager.lightdm.enable = true;
    };
  };

  sops.secrets = {
    "api/youtube" = {
      owner = config.users.users.kodi.name;
      mode = "0400";
      path = "${config.users.users.kodi.home}/.kodi/userdata/addon_data/plugin.video.youtube/api_keys.json";
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
      # Should be fine with remote build
      # #To prevent builds to fill all remaining space
      # "/tmp"
      # "/var/tmp"
      {
        directory = "/etc/ssh/";
        mode = "0700";
      }
      "/run/secrets.d"
    ];
    users.kodi = {
      directories = [ ".kodi" ];
    };
  };

  systemd.tmpfiles.rules = [
    "d /home/kodi/.config 0755 kodi users -"
  ];

  system.stateVersion = "25.11";

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  users = {
    mutableUsers = false;
  };

  nix.settings = {
    cores = 1;
    max-jobs = 1;
  };

  # Avoid to rebuild linux kernel
  nix.settings = {
    substituters = [ "https://nixos-raspberrypi.cachix.org" ];
    trusted-public-keys = [
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
    ];
  };

  hostServices.vpn-client = {
    enable = true;
    ipv4 = "10.20.0.7/24";
    ipv6 = "fd8c:70ee:bdd8:1:1::3/128";
    privateKeySecret = "wg/bxl-shp/media-center/key";
    route = {
      bxl = true;
    };
    autostart = true;
  };
}
