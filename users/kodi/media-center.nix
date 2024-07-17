{ ... }:
{
  imports = [ ./default.nix ];

  sops.secrets = {
    "wg/bxl-shp/media-server/key" = { };
    "wg/bxl-shp/media-server/psk" = { };
  };

  networking.wg-quick.interfaces.bxl-shp = {
    address = [ "10.15.14.5/32" ];
    privateKeyFile = "/run/secrets/wg/bxl-shp/media-server/key";
    dns = [ "10.15.14.1" ];
    autostart = true;
    peers = [
      {
        publicKey = "Ft1qUCCs9GkpUfiotZU9Ueq1e9ncXr0PwWEyfLoc6Vs=";
        presharedKeyFile = "/run/secrets/wg/bxl-shp/media-server/psk";
        allowedIPs = [ "0.0.0.0/0" ];
        endpoint = "vpn.bhasher.com:51822";
        persistentKeepalive = 25;
      }
    ];
  };
}
