{ ... }:
{
  imports = [
    ./default.nix
  ];

  sops.secrets = {
    "wg/bxl-shp/desktop/key" = { };
    "wg/bxl-shp/desktop/psk" = { };
  };

  networking = {
    wg-quick.interfaces.bxl-shp = {
      address = [ "10.15.14.3/32" ];
      privateKeyFile = "/run/secrets/wg/bxl-shp/desktop/key";
      dns = [
        # "10.15.14.1"
        # "1.1.1.1"
        # "192.168.1.221"
      ];
      autostart = true;
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
    hosts = {
      "192.168.1.221" = [
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
