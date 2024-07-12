{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../shared/global
    ../shared/pc
  ];

  # Lanzaboote require some manual steps
  # `sbctl create-keys`
  # `sbctl verify` # Everything except the kernel should be signed
  # Enable secure boot in the BIOS
  # `sbctl enroll`
  # reboot
  # `bootctl status`
  boot.loader.systemd-boot.enable = false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };

  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "desktop";

  services.displayManager.autoLogin = {
    enable = true;
    user = "bhasher";
  };

  system.stateVersion = "23.11";
}
