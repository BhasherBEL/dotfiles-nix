{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../shared/global
    ../shared/pc
    ../shared/users/bhasher.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices."luks-bf6108ec-6c51-44c7-b5cd-88101ee16aa0".device = "/dev/disk/by-uuid/bf6108ec-6c51-44c7-b5cd-88101ee16aa0";

  powerManagement.enable = true;

  networking = {
    hostName = "laptop";

    wg-quick.interfaces.bxl-shp = {
      address = [ "10.15.14.6/32" ];
      privateKeyFile = "/etc/wireguard/bxl-shp.key";
      dns = [ "10.15.14.1" ];
      autostart = true;
      peers = [
        {
          publicKey = "Ft1qUCCs9GkpUfiotZU9Ueq1e9ncXr0PwWEyfLoc6Vs=";
          presharedKeyFile = "/etc/wireguard/bxl-shp.psk";
          allowedIPs = [ "0.0.0.0/0" ];
          endpoint = "vpn.bhasher.com:51822";
          persistentKeepalive = 25;
        }
      ];
    };
  };

  services = {
    displayManager.autoLogin = {
      enable = true;
      user = "bhasher";
    };
    # Prevent overheating of Intel CPUs
    thermald.enable = true;
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 20;
      };
    };
  };

  system.stateVersion = "23.11";
}
