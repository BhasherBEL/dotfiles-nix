{ ... }:
{
  imports = [
    ./hardware-configuration.nix
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

  hostServices.vpn-client = {
    enable = true;
    ipv4 = "10.20.0.4/24";
    ipv6 = "fd8c:70ee:bdd8:1:1::2/128";
    privateKeySecret = "wg/bxl-shp/desktop/key";
    routeAll = false;
    routeLan = false;
    autostart = true;
  };

  system.stateVersion = "23.11";
}
