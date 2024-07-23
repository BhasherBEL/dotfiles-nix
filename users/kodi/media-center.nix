{ ... }:
{
  imports = [ ./default.nix ];

  sops.secrets = {
    "wg/bxl-shp/media-server/key" = { };
    "wg/bxl-shp/media-server/psk" = { };
  };

  networking.wireguard.interfaces.bxl-shp = {
    ips = [ "10.15.14.5/24" ];
    privateKeyFile = "/run/secrets/wg/bxl-shp/media-server/key";
    peers = [
      {
        publicKey = "Ft1qUCCs9GkpUfiotZU9Ueq1e9ncXr0PwWEyfLoc6Vs=";
        presharedKeyFile = "/run/secrets/wg/bxl-shp/media-server/psk";
        allowedIPs = [
          "10.15.14.0/24"
          "192.168.1.0/24"
        ];
        endpoint = "vpn.bhasher.com:51822";
        persistentKeepalive = 25;
      }
    ];
  };
}
