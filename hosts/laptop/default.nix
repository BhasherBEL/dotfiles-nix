{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../shared/global
    ../shared/pc
    ../shared/laptop
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd = {
    kernelModules = [
      "vfat"
      "nls_cp437"
      "nls_iso8859-1"
      "usbhid"
    ];
    luks = {
      #yubikeySupport = true;
      devices."luks-bf6108ec-6c51-44c7-b5cd-88101ee16aa0" = {
        device = "/dev/disk/by-uuid/bf6108ec-6c51-44c7-b5cd-88101ee16aa0";
        #yubikey = {
        #  slot = 2;
        #  twoFactor = false;
        #  storage.device = "/dev/nvme0n1p1";
        #};
      };
    };
  };

  networking = {
    hostName = "laptop";
  };

  environment.systemPackages = with pkgs; [
    cryptsetup
    gcc
    openssl
    yubikey-personalization
  ];

  system.stateVersion = "23.11";
}
