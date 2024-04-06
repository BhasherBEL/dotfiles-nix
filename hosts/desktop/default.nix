{ ... }: {
  imports = [
    ./hardware-configuration.nix
    ../shared/global
    ../shared/pc
    ../shared/users/bhasher
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "desktop";

    wg-quick.interfaces.bxl-shp = {
      address = [ "10.15.14.3/32" ];
      privateKeyFile = "/etc/wireguard/bxl-shp.key";
      dns = [ "10.15.14.1" ];
      autostart = true;
      peers = [{
        publicKey = "Ft1qUCCs9GkpUfiotZU9Ueq1e9ncXr0PwWEyfLoc6Vs=";
        presharedKeyFile = "/etc/wireguard/bxl-shp.psk";
        allowedIPs = [ "0.0.0.0/0" ];
        endpoint = "vpn.bhasher.com:51822";
        persistentKeepalive = 25;
      }];
    };
  };

  services.xserver.displayManager.autoLogin = {
    enable = true;
    user = "bhasher";
  };

  system.stateVersion = "23.11";
}

