{ lib, ... }:
{
  imports = [
    ./default.nix
    ../optional/go.nix
    ../optional/eid.nix
    ../optional/wifi-crack.nix
    ../optional/docker.nix
  ];

  sops.secrets = {
    "wg/bxl-shp/laptop/key" = { };
    "wg/bxl-shp/laptop/psk" = { };
  };

  networking = {
    wg-quick.interfaces.bxl-shp = {
      address = [ "10.15.14.6/32" ];
      privateKeyFile = "/run/secrets/wg/bxl-shp/laptop/key";
      #dns = [ "10.15.14.1" ];
      dns = [ "1.1.1.1" ];
      autostart = true;
      peers = [
        {
          publicKey = "Ft1qUCCs9GkpUfiotZU9Ueq1e9ncXr0PwWEyfLoc6Vs=";
          presharedKeyFile = "/run/secrets/wg/bxl-shp/laptop/psk";
          allowedIPs = [
            #"10.15.14.0/24"
            #"192.168.1.0/24"
            "0.0.0.0/0"
          ];
          endpoint = "vpn.bhasher.com:51822";
          persistentKeepalive = 25;
        }
      ];
    };
  };

  services.greetd.settings.default_session.user = "bhasher";

  time.timeZone = lib.mkForce "Europe/Helsinki";

  modules = {
    classes = {
      master-thesis.enable = true;
      cs-c3170-web-software-development.enable = true;
    };
    flutter.enable = false;
  };
}
