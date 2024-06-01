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
