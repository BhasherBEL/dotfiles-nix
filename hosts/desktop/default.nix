{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../shared/global
    ../shared/pc
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "desktop";

  services.displayManager.autoLogin = {
    enable = true;
    user = "bhasher";
  };

  system.stateVersion = "23.11";
}
