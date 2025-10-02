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
        "bxl.bhasher.com" = "91.182.226.236";
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
    };
    firefly-iii.enable = true;
    syncthing.enable = true;
  };
}
