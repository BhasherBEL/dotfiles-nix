{ lib, config, ... }:
{
  options = {
    hostServices.dyndns = {
      wol.enable = lib.mkEnableOption "Enable DynDns";
    };
  };

  config = lib.mkIf config.hostServices.dyndns.wol.enable {
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
      domains = [
        "wol.bhasher.com"
      ];
    };
  };
}
