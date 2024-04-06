{ ... }: {
  imports = [
    ./hardware-configuration.nix
    ../shared/global
    ../shared/users/kodi.nix
  ];

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  networking = { hostName = "media-center"; };

  services.openssh.enable = true;

  system.stateVersion = "23.11";
}

