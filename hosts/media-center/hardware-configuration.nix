{ lib, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = [
      "defaults"
      "size=25%"
      "mode=755"
    ];
  };
  fileSystems."/home/kodi" = {
    device = "none";
    fsType = "tmpfs";
    options = [
      "defaults"
      "size=25%"
      "mode=777"
    ];
  };
  fileSystems."/sd-card" = {
    neededForBoot = true;
    device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888";
    fsType = "ext4";
  };
  fileSystems."/nix" = {
    device = "/sd-card/nix";
    options = [ "bind" ];
  };
  fileSystems."/boot" = {
    device = "/sd-card/boot";
    options = [ "bind" ];
  };
  fileSystems."/persistent" = {
    neededForBoot = true;
    device = "/sd-card/persistent";
    options = [ "bind" ];
  };

  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
