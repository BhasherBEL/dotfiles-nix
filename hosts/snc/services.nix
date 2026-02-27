{ ... }:
{
  hostServices = {
    # nginx.enable = true;
    vpn-client = {
      enable = true;
      ipv4 = "10.20.0.9/24";
      ipv6 = "fd8c:70ee:bdd8:3:1::1/128";
      privateKeySecret = "wg/bxl-shp/snc/key";
      autostart = true;
    };
  };
}
