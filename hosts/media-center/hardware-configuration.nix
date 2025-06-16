{ lib, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    kernelParams = [
      "snd_bcm2835.enable_hdmi=1"
      "snd_bcm2835.enable_headphones=1"
    ];
    loader.raspberryPi.firmwareConfig = ''
      			dtparam=audio=on
      		'';
  };

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

  networking.useDHCP = lib.mkDefault true;
  networking.networkmanager.wifi.powersave = false;

  nixpkgs.hostPlatform = "aarch64-linux";
}
