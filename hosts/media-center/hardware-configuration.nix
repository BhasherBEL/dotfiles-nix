{ lib, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    kernelParams = [
      "snd_bcm2835.enable_hdmi=1"
      "snd_bcm2835.enable_headphones=1"
    ];
  };

  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [
        "defaults"
        "size=25%"
        "mode=755"
      ];
    };
    "/home/kodi" = {
      device = "none";
      fsType = "tmpfs";
      options = [
        "defaults"
        "size=25%"
        "mode=777"
      ];
    };
    "sd-card" = {
      neededForBoot = true;
      device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888";
      fsType = "ext4";
    };
    "nix" = {
      device = "/sd-card/nix";
      options = [ "bind" ];
    };
    "boot" = {
      device = "/sd-card/boot";
      options = [ "bind" ];
    };
    "/persistent" = {
      neededForBoot = true;
      device = "/sd-card/persistent";
      options = [ "bind" ];
    };
  };

  networking.useDHCP = lib.mkDefault true;
  networking.networkmanager.wifi.powersave = false;

  nixpkgs.hostPlatform = "aarch64-linux";
}
