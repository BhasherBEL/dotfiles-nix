{ lib, config, ... }:
{
  options = {
    hostServices.dyndns = {
      wol.enable = lib.mkEnableOption "Enable DynDns for wol";
      bxl.enable = lib.mkEnableOption "Enable DynDns for bxl";
    };
  };

  config =
    lib.mkIf config.hostServices.dyndns.wol.enable {
      sops.secrets = {
        "services/dyndns/wol" = { };
      };

      services.ddclient = {
        enable = true;
        username = "bhasher.com-shp";
        server = "www.ovh.com";
        protocol = "dyndns2";
        passwordFile = "/run/secrets/services/dyndns/wol";
        interval = "10min";
        usev4 = "webv4, webv4=ipify-ipv4";
        domains = [
          "wol.bhasher.com"
        ];
      };
    }
    // lib.mkIf config.hostServices.dyndns.bxl.enable {
      sops.secrets = {
        "services/dyndns/bxl" = { };
      };

      services.ddclient = {
        enable = true;
        username = "bhasher.com-bxl";
        server = "www.ovh.com";
        # protocol = "dyndns2";
        protocol = "ovh";
        passwordFile = "/run/secrets/services/dyndns/bxl";
        interval = "10min";
        # use = "webv4, webv4=ipify-ipv4";
        usev4 = "webv4,webv4=ipify-ipv4";
        usev6 = "disabled";
        domains = [
          "bxl.bhasher.com"
        ];
      };
    };
}
