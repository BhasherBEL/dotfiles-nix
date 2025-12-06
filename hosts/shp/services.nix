{ ... }:
{
  hostServices = {
    nginx.enable = true;
    dyndns.wol.enable = true;
    vpn = {
      enable = true;
      interface = "eno1";
    };
    dns = {
      enable = true;
      mappings = {
        "bxl.bhasher.com" = "62.235.48.154";
        "smtp.bhasher.com" = "51.255.172.55";
        "imap.bhasher.com" = "51.255.172.55";
        "autoconfig.bhasher.com" = "51.255.172.55";
        "mail.bhasher.com" = "51.255.172.55";
        "bhasher.com" = "192.168.0.201";
      };
    };
    auth.authelia.enable = true;
    mediaserver = {
      jellyfin.enable = true;
      servarr.enable = true;
      transmission.enable = true;
    };
    firefly-iii.enable = true;
    syncthing.enable = true;
    owntracks.enable = true;
    vaultwarden.enable = true;
    jupyter-hub.enable = true;
    miniflux.enable = true;
    radicale.enable = true;
    restic.enable = true;
    paperless.enable = true;
    otp.enable = true;
  };
}
