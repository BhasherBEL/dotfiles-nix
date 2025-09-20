{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.hostServices.storage.postgresql;
in
{
  options = {
    hostServices.storage.postgresql = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = cfg.databases != [ ] || cfg.users != [ ] || cfg.access != [ ];
        description = "Enable postgresql database service";
      };
      databases = lib.mkOption {
        type = with lib.types; listOf str;
        default = [ ];
        description = "List of databases to create on setup.";
      };
      users = lib.mkOption {
        type = with lib.types; listOf str;
        default = [ ];
        description = "List of users to create on setup.";
      };
      access = lib.mkOption {
        type = with lib.types; listOf str;
        default = [ ];
        description = "List of databases and users to grant access. User and database will have the same name.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.postgresql = {
      enable = true;
      enableTCPIP = false;
      package = pkgs.postgresql_18;
      dataDir = "/var/lib/postgresql/${config.services.postgresql.package.psqlSchema}";
      ensureDatabases = cfg.databases ++ cfg.access;
      ensureUsers =
        map (name: { inherit name; }) cfg.users
        ++ map (name: {
          inherit name;
          ensureDbOwnership = true;
        }) cfg.access;
    };

    environment.persistence."/persistent" = {
      enable = lib.mkDefault false;
      directories = [
        "/var/lib/postgresql"
      ];
    };
  };
}
