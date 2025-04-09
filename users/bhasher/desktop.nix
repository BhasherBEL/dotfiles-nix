{ ... }:
{
  imports = [
    ./default.nix
  ];

  sops.secrets = {
    "wg/bxl-shp/desktop/key" = { };
    "wg/bxl-shp/desktop/psk" = { };
  };

  networking.wg-quick.interfaces.bxl-shp = {
    address = [ "10.15.14.3/32" ];
    privateKeyFile = "/run/secrets/wg/bxl-shp/desktop/key";
    dns = [
      "10.15.14.1"
      "1.1.1.1"
    ];
    autostart = true;
    peers = [
      {
        publicKey = "Ft1qUCCs9GkpUfiotZU9Ueq1e9ncXr0PwWEyfLoc6Vs=";
        presharedKeyFile = "/run/secrets/wg/bxl-shp/desktop/psk";
        allowedIPs = [
          "0.0.0.0/0"
          "192.168.1.0/24"
        ];
        endpoint = "vpn.bhasher.com:51822";
        persistentKeepalive = 25;
      }
    ];
  };

  modules = {
    bluetooth.enable = true;
    classes = {
      master-thesis.enable = true;
    };
  };
}
