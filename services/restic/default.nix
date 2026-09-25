{ lib, config, ... }:
let
  cfg = config.hostServices.restic;
in
{
  options = {
    hostServices.restic = {
      enable = lib.mkEnableOption "Enable restic";
      paths = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
      };
    };
  };

  config = lib.mkIf cfg.enable {
    sops = {
      secrets = {
        "services/restic/password" = {
          owner = config.services.restic.backups.synnas.user;
          # owner = "root";
        };
        "smb/synnas" = { };
      };
      templates = {
        "restic-rclone.conf".content = ''
          [synnas]
          type = smb
          host = 192.168.1.201
          user = Brieuc
          pass = ${config.sops.placeholder."smb/synnas"}
        '';
      };
    };

    services = {
      restic.backups = {
        synnas = {
          initialize = true;
          paths = cfg.paths;
          repository = "rclone:synnas:Brieuc/Backup/auto/${config.networking.hostName}";
          passwordFile = config.sops.secrets."services/restic/password".path;
          rcloneConfigFile = config.sops.templates."restic-rclone.conf".path;
          timerConfig = {
            OnCalendar = "daily";
            Persistent = true;
            RandomizedDelaySec = "1h";
          };
          pruneOpts = [
            "--keep-daily 10"
            "--keep-weekly 5"
            "--keep-monthly 15"
            "--keep-yearly 10"
          ];
        };
      };
    };
  };
}
