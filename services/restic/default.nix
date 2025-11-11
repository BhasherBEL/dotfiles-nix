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
    sops.secrets = {
      "services/restic/password" = {
        owner = config.services.restic.backups.truenas.user;
      };
      "smb/truenas" = {
        mode = "0444";
      };
    };

    fileSystems."/mnt/truenas/backup" = {
      device = "192.168.1.201:/mnt/Main/redondant/backup/restic/shp";
      fsType = "nfs";
      options = [
        "nfsvers=3"
        "proto=tcp"
        "hard"
        "intr"
        "rsize=65536"
        "wsize=65536"
        "noatime"
        "nodiratime"
        "actimeo=30"
        "x-systemd.automount"
        "noauto"
        "x-systemd.idle-timeout=600"
      ];
    };
    boot.supportedFilesystems = [ "nfs" ];

    services = {
      restic.backups = {
        truenas = {
          initialize = true;
          paths = cfg.paths;
          passwordFile = config.sops.secrets."services/restic/password".path;
          repository = "/mnt/truenas/backup/auto";
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
