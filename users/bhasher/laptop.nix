{ pkgs, ... }:
{
  imports = [
    ./default.nix
  ];

  modules = {
    bluetooth.enable = true;
  };

  networking = {
    wg-quick.interfaces = {
      bxl-mikrotik = {
        address = [ "10.3.0.2/32" ];
        privateKeyFile = "/run/secrets/wg/bxl-mikrotik/second/key";
        dns = [ ];
        autostart = false;
        peers = [
          {
            publicKey = "6C0S6WyXNuVeiDIY4rV2LbJCxfI5Qnz5/ATKrRyrGTM=";
            allowedIPs = [
              "10.3.0.0/24"
              "192.168.1.0/24"
            ];
            endpoint = "vpn.bxl.bhasher.com:13232";
            persistentKeepalive = 25;
          }
        ];
      };
    };
  };

  environment.systemPackages = [
    pkgs.transmission_4-qt
  ];

  hostServices.vpn-client = {
    enable = true;
    ipv4 = "10.20.0.3/24";
    # ipv6 = "fd8c:70ee:bdd8:0:1::3/128";
    privateKeySecret = "wg/bxl-shp/laptop/key";
    route = {
      all = false;
      bxl = true;
      wol = true;
    };
    autostart = true;
  };
}
