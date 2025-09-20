{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.hostServices.storage.valkey;
in
{
  options = {
    hostServices.storage.valkey = {
      enable = lib.mkEnableOption "Enable Valkey service";
    };
  };

  config = lib.mkIf cfg.enable {
    services.redis = {
      enable = true;
      package = pkgs.valkey;
      servers."" = {
        user = "valkey";
        unixSocket = /run/valkey/valkey.sock;
      };
    };
  };
}
