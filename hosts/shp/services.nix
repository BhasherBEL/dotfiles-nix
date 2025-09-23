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
        "bhasher.com" = "192.168.0.201";
      };
    };
    auth.authelia.enable = true;
  };
}
