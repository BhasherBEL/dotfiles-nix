{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../shared/global
    ../shared/pc
    ../shared/laptop
  ];

  # Lanzaboote require some manual steps
  # `subctl create-keys`
  # `subctl verify` # Everything except the kernel should be signed
  # Enable secure boot in the BIOS
  # `subctl enroll`
  # reboot
  # `bootctl status`
  boot.loader.systemd-boot.enable = false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot/";
  };

  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "laptop";

  environment.systemPackages = with pkgs; [ cryptsetup ];

  system.stateVersion = "23.11";
}
