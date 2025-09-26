{ lib, ... }:
{
  imports = [
    ./default.nix
  ];

  sops.secrets = {
    "wg/bxl-shp/laptop/key" = { };
    "wg/bxl-shp/laptop/psk" = { };
  };

  networking = {
    wg-quick.interfaces.bxl-shp = {
      address = [ "10.20.0.3/32" ];
      privateKeyFile = "/run/secrets/wg/bxl-shp/laptop/key";
      dns = [ "10.20.0.1" ];
      autostart = true;
      peers = [
        {
          publicKey = "Ft1qUCCs9GkpUfiotZU9Ueq1e9ncXr0PwWEyfLoc6Vs=";
          allowedIPs = [
            "10.20.0.0/24"
            "192.168.1.0/24"
          ];
          endpoint = "vpn.wol.bhasher.com:51824";
          persistentKeepalive = 25;
        }
      ];
    };
  };

  modules = {
    bluetooth.enable = true;
    docker.enable = true;
    ipv6.disable = true;
  };
}
