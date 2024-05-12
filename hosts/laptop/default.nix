{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../shared/global
    ../shared/pc
    ../shared/laptop
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices."luks-bf6108ec-6c51-44c7-b5cd-88101ee16aa0".device = "/dev/disk/by-uuid/bf6108ec-6c51-44c7-b5cd-88101ee16aa0";

  networking = {
    hostName = "laptop";
  };

  system.stateVersion = "23.11";
}
