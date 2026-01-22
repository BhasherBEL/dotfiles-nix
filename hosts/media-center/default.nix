{
  lib,
  modulesPath,
  pkgs,
  config,
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
            jellyfin
            netflix
            # invidious
            arteplussept
            sponsorblock
            inputstreamhelper
            (youtube.overrideAttrs (old: rec {
              name = "youtube-${version}";
              version = "7.4.0+beta.4";
              src = old.src.override {
                owner = "anxdpanic";
                repo = "plugin.video.youtube";
                rev = "v${version}";
                hash = "sha256-Q1y9NKShNHS7y6CSm1g8xbbTjJA9fyRR3DCxF5vtjCU=";
              };
            }))
            (pkgs.kodiPackages.callPackage ./custom-addons/bluetooth-manager { })
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

  hostModules = {
    # remoteBuild = {
    #   enable = true;
    #   only = true;
    #   oa-fw = true;
    # };
  };

  nix.settings = {
    cores = 1;
    max-jobs = 1;
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
