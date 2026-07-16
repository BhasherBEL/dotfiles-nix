{
  lib,
  config,
  ...
}:
let
  cfg = config.hostServices.iodine;
in
{
  options = {
    hostServices.iodine = {
      enable = lib.mkEnableOption "Enable iodine service";
      hostname = lib.mkOption {
        type = lib.types.str;
        default = "dvpn.bhasher.com";
        description = "The hostname for iodine";
      };
      port = lib.mkOption {
        type = lib.types.port;
        default = 5354;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets."services/iodine/password" = { };

    services.iodine.server = {
      enable = true;
      domain = cfg.hostname;
      passwordFile = config.sops.secrets."services/iodine/password".path;
      ip = "10.20.2.1";
      extraConfig = lib.concatStringsSep " " [
        "-p ${toString cfg.port}"
      ];
    };

    networking.firewall = {
      allowedUDPPorts = [ cfg.port ];
    };
  };
}
