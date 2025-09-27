{ ... }:
{
  imports = [
    ./default.nix
  ];

  modules = {
    bluetooth.enable = true;
    docker.enable = true;
  };

  hostServices.vpn-client = {
    enable = true;
    ipv4 = "10.20.0.3/24";
    # ipv6 = "fd8c:70ee:bdd8:0:1::3/128";
    privateKeySecret = "wg/bxl-shp/laptop/key";
    route = {
      all = true;
      bxl = true;
      wol = true;
    };
    autostart = true;
  };
}
