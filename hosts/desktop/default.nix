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

  hostServices = {
    vpn = {
      enable = true;
      interface = "enp0s31f6";
    };
    dns = {
      enable = true;
      mappings = {
        "bxl.bhasher.com" = "91.182.226.236";
        "bhasher.com" = "192.168.1.201";
      };
    };
    auth.openldap.enable = true;
  };

  system.stateVersion = "23.11";
}
