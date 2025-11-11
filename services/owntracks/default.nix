{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.hostServices.owntracks;
in
{
  options.hostServices.owntracks = {
    enable = lib.mkEnableOption "Enable owntracks";
    hostname = lib.mkOption {
      type = lib.types.str;
      default = "owntracks.bhasher.com";
      description = "The hostname for owntracks";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      owntracks-recorder
    ];

    users = {
      users.owntracks = {
        isSystemUser = true;
        group = "owntracks";
      };
      groups.owntracks = { };
    };

    systemd.services.owntracks = {
      description = "owntracks Recorder";
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];

      serviceConfig = {
        Type = "simple";
        StateDirectory = "owntracks";
        Restart = "on-failure";
        User = "owntracks";
        Group = "owntracks";
        ExecStart =
          "${pkgs.owntracks-recorder}/bin/ot-recorder"
          + " --storage /var/lib/owntracks"
          + " --doc-root ${pkgs.owntracks-recorder.src}/docroot"
          + " --port 0" # Disable MQTT
          + " 'owntracks/#'";
      };
    };

    services = {
      nginx.virtualHosts."${cfg.hostname}" = {
        forceSSL = true;
        enableACME = true;
        locations = {
          "/ws" = {
            proxyPass = "http://127.0.0.1:8083";
            proxyWebsockets = true;
            recommendedProxySettings = true;
          };
          "/" = {
            proxyPass = "http://127.0.0.1:8083/";
            recommendedProxySettings = true;
            extraConfig = "include ${config.hostServices.auth.authelia.snippets.request};";
          };
          "/pub" = {
            proxyPass = "http://127.0.0.1:8083/pub";
            recommendedProxySettings = true;
          };
          "/internal/authelia/authz" = {
            recommendedProxySettings = false;
            extraConfig = "include ${config.hostServices.auth.authelia.snippets.location};";
          };
        };
      };
    };

    environment.persistence."/persistent" = {
      enable = lib.mkDefault false;
      directories = [
        "/var/lib/owntracks"
      ];
    };

    hostServices.restic.paths = [ "/persistent/var/lib/owntracks" ];
  };
}
