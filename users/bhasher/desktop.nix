{ ... }:
{
  imports = [
    ./default.nix
  ];

  sops.secrets = {
    "wg/bxl-shp/desktop/key" = { };
    "wg/bxl-shp/desktop/psk" = { };
    "wg/bxl-mikrotik/second/key" = { };
  };

  networking = {
    wg-quick.interfaces = {
      bxl-shp = {
        address = [ "10.15.14.3/32" ];
        privateKeyFile = "/run/secrets/wg/bxl-shp/desktop/key";
        dns = [
          # "10.15.14.1"
          # "1.1.1.1"
          # "192.168.1.221"
        ];
        autostart = false;
        peers = [
          {
            publicKey = "Ft1qUCCs9GkpUfiotZU9Ueq1e9ncXr0PwWEyfLoc6Vs=";
            presharedKeyFile = "/run/secrets/wg/bxl-shp/desktop/psk";
            allowedIPs = [
              # "0.0.0.0/0"
              "10.15.14.0/24"
              "192.168.1.0/24"
              # "91.182.226.236/32"
            ];
            endpoint = "vpn.bhasher.com:51822";
            persistentKeepalive = 25;
          }
        ];
      };
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
            endpoint = "vpn.bhasher.com:13232";
            persistentKeepalive = 25;
          }
        ];
      };
    };
    hosts = {
      "192.168.0.201" = [
        "pihole.bhasher.com"
        "firefly.bhasher.com"
        "prowlarr.bhasher.com"
        "radarr.bhasher.com"
        "sonarr.bhasher.com"
        "ntfy.bhasher.com"
        "transmission.bhasher.com"
        "bazarr.bhasher.com"
        "homepage.bhasher.com"
        "miniflux.bhasher.com"
        "grafana.bhasher.com"
        "joplin.bhasher.com"
        "paperless.bhasher.com"
        "matrix.bhasher.com"
        "hass.bhasher.com"
        "syncthing.bhasher.com"
        "baikal.bhasher.com"
        "lum.bhasher.com"
        "dmarc.bhasher.com"
        "owntracks.bhasher.com"
        "invoice.bhasher.com"
      ];
    };
  };

  modules = {
    bluetooth.enable = true;
  };
}
