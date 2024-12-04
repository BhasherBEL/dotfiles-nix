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
      address = [ "10.15.14.6/32" ];
      privateKeyFile = "/run/secrets/wg/bxl-shp/laptop/key";
      dns = [ "1.1.1.1" ];
      autostart = true;
      peers = [
        {
          publicKey = "Ft1qUCCs9GkpUfiotZU9Ueq1e9ncXr0PwWEyfLoc6Vs=";
          presharedKeyFile = "/run/secrets/wg/bxl-shp/laptop/psk";
          allowedIPs = [
            "0.0.0.0/0"
          ];
          endpoint = "91.182.226.236:51822";
          persistentKeepalive = 25;
        }
      ];
    };
  };

  time.timeZone = lib.mkForce "Europe/Helsinki";

  modules = {
    bluetooth.enable = true;
    docker.enable = true;
    classes = {
      master-thesis = {
        enable = true;
        iface = "wlp0s20f3";
      };
      cs-c3170-web-software-development.enable = true;
      aalto.enable = true;
    };
  };
}
