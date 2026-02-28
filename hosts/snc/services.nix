{ ... }:
{
  hostServices = {
    nginx = {
      enable = true;
      https = false;
      https-bis = false;
    };
    vpn-client = {
      enable = true;
      ipv4 = "10.20.0.9/24";
      ipv6 = "fd8c:70ee:bdd8:3:1::1/128";
      privateKeySecret = "wg/bxl-shp/snc/key";
      autostart = true;
    };
    mailserver.enable = true;
  };
}
