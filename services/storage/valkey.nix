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
      package = pkgs.valkey;
      servers."" = {
        enable = true;
        user = "valkey";
        group = "valkey";
        unixSocket = "/run/valkey/valkey.sock";
      };
    };

    systemd.tmpfiles.rules = [
      "d /run/valkey 0755 valkey valkey -"
    ];

    users = {
      users.valkey = {
        isSystemUser = true;
        group = "valkey";
      };
      groups.valkey = { };
    };
  };
}
