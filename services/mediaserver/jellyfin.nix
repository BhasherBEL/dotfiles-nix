{ lib, config, ... }:
let
  cfg = config.hostServices.mediaserver.jellyfin;
  cifsOptions = [
    "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,credentials=/run/secrets/smb/truenas,uid=1000,gid=983,dir_mode=0775,file_mode=0775"
  ];
in
{
  options = {
    hostServices.mediaserver.jellyfin = {
      enable = lib.mkEnableOption "Enable Jellyfin media server";
      hostname = lib.mkOption {
        type = lib.types.str;
        default = "jellyfin.bhasher.com";
        description = "The hostname of jellyfin";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets = {
      "smb/truenas" = {
        mode = "0444";
      };
    };

    fileSystems."/mnt/truenas/media" = {
      device = "//192.168.1.201/movies";
      fsType = "cifs";
      options = cifsOptions;
    };

    services = {
      jellyfin = {
        enable = true;
        user = "jellyfin";
        dataDir = "/var/lib/jellyfin";
      };
      nginx.virtualHosts."${cfg.hostname}" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          recommendedProxySettings = true;
          proxyPass = "http://127.0.0.1:8096";
        };
      };
    };

    environment.persistence."/persistent" = {
      enable = lib.mkDefault false;
      directories = [
        {
          directory = "/var/lib/jellyfin";
          user = config.services.jellyfin.user;
          group = config.services.jellyfin.group;
        }
      ];
    };
  };
}
