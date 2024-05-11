{ ... }:
{
  imports = [ ./default.nix ];

  networking.wg-quick.interfaces.bxl-shp = {
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

  services.displayManager.autoLogin = {
    enable = true;
    user = "bhasher";
  };
}
