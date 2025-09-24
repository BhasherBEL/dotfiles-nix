{ pkgs, ... }:
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

  environment.systemPackages = with pkgs; [
    gparted
  ];
  security.polkit.enable = true;

  modules = {
    bluetooth.enable = true;
  };
}
