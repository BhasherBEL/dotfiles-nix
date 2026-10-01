{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.hostServices.mailserver.dmarc-report-viewer;
in
{
  options = {
    hostServices.mailserver.dmarc-report-viewer = {
      enable = lib.mkEnableOption "Enable dmarc-report-viewer";
      hostname = lib.mkOption {
        type = lib.types.str;
        default = "dmarc.bhasher.com";
        description = "The hostname for dmarc-report-viewer";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets = {
      "services/dmarc-report-viewer/env" = { };
    };

    systemd.services = {
      dmarc-report-viewer = {
        description = "DMARC Report Viewer";
        wantedBy = [ "multi-user.target" ];
        after = [
          "network.target"
          "dovecot2.service"
        ];

        environment = {
          IMAP_HOST = "mail01.bhasher.com";
          IMAP_USER = "main@bhasher.com";
          IMAP_FOLDER = "reports/dmarc/inbox";
          HTTP_SERVER_BINDING = "127.0.0.1";
          HTTP_SERVER_PORT = "34028";
          HTTP_SERVER_PASSWORD = "";
        };

        serviceConfig = {
          ExecStart = "${pkgs.dmarc-report-viewer}/bin/dmarc-report-viewer";
          EnvironmentFile = config.sops.secrets."services/dmarc-report-viewer/env".path;
          DynamicUser = true;
          Restart = "on-failure";
          NoNewPrivileges = true;
          ProtectSystem = "strict";
          ProtectHome = true;
          PrivateTmp = true;
        };
      };
    };

    services = {
      nginx.virtualHosts."${cfg.hostname}" = {
        forceSSL = true;
        enableACME = true;
        locations = {
          "/" = {
            proxyPass = "http://127.0.0.1:34028";
            recommendedProxySettings = true;
            extraConfig = "include ${config.hostServices.auth.authelia.snippets.request};";
          };
          "/internal/authelia/authz" = {
            recommendedProxySettings = false;
            extraConfig = "include ${config.hostServices.auth.authelia.snippets.location};";
          };
        };
      };
    };
  };
}
