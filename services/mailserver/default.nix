{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.hostServices.mailserver;
  mailcfg = config.mailserver;
  gatus_url = "http://10.20.0.1:61303";
in
{
  imports = [
    inputs.simple-nixos-mailserver.nixosModule
  ];

  options = {
    hostServices.mailserver = {
      enable = lib.mkEnableOption "Enable mailserver";
      fqdn = lib.mkOption {
        type = lib.types.str;
        default = "mail01.bhasher.com";
        description = "The hostname for mealie";
      };
      domains = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ "bhasher.com" ];
      };
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets = {
      "services/mail/bhasher-bhasher.com".restartUnits = [ "dovecot.service" ];
      "services/mail/scaleway-tem".restartUnits = [ "postfix.service" ];
      "services/gatus/env" = { };
    };

    mailserver = {
      enable = true;
      stateVersion = 5;
      openFirewall = false;
      fqdn = cfg.fqdn;
      domains = cfg.domains;
      x509.useACMEHost = cfg.fqdn;

      enableImap = false;
      enableImapSsl = true;
      enableSubmission = false;
      enableSubmissionSsl = true;
      enablePop3 = false;
      enablePop3Ssl = false;
      enableManageSieve = true;

      virusScanning = false;
      fullTextSearch.enable = false;

      accounts."main@bhasher.com" = {
        aliases = map (d: "@${d}") cfg.domains;
        hashedPasswordFile = config.sops.secrets."services/mail/bhasher-bhasher.com".path;
      };

      dkim.domains = lib.genAttrs cfg.domains (_: {
        selectors."rsa-2026-09" = { };
      });
    };

    services = {
      nginx.virtualHosts.${cfg.fqdn} = {
        enableACME = true;
        locations."/".return = "444";
      };
      postfix.settings.main = {
        relayhost = [ "[smtp.tem.scaleway.com]:2587" ];
        smtp_sasl_auth_enable = true;
        smtp_sasl_password_maps = "texthash:${config.sops.secrets."services/mail/scaleway-tem".path}";
        smtp_sasl_security_options = "noanonymous";
        smtp_sasl_tls_security_options = "noanonymous";
        smtp_tls_security_level = lib.mkForce "secure";
      };
    };

    networking.firewall = {
      enable = true;
      allowedTCPPorts = [
        25
      ];
      interfaces.wg0 = {
        allowedTCPPorts =
          lib.optional mailcfg.enableSubmissionSsl 465
          ++ lib.optional mailcfg.enableImapSsl 993
          ++ lib.optional mailcfg.enablePop3Ssl 995
          ++ lib.optional mailcfg.enableManageSieve 4190;
      };
    };

    hostServices.restic.paths = [
      "/var/vmail"
      "/var/dkim"
      "/var/lib/redis-rspamd"
    ];

    systemd.services = {
      "gatus-ok@" = {
        path = [ pkgs.curl ];
        scriptArgs = "%i";
        serviceConfig = {
          Type = "oneshot";
          EnvironmentFile = config.sops.secrets."services/gatus/env".path;
        };
        script = ''
          curl -fsS --retry 3 -X POST \
            -H "Authorization: Bearer $GATUS_PUSH_TOKEN" \
            --url-query "success=true" \
            "${gatus_url}/api/v1/endpoints/$1/external"
        '';
      };

      "gatus-fail@" = {
        path = [ pkgs.curl ];
        scriptArgs = "%i";
        serviceConfig = {
          Type = "oneshot";
          EnvironmentFile = config.sops.secrets."services/gatus/env".path;
        };
        script = ''
          curl -fsS --retry 3 -X POST \
            -H "Authorization: Bearer $GATUS_PUSH_TOKEN" \
            --url-query "success=false" \
            --url-query "error=unit failed" \
            "${gatus_url}/api/v1/endpoints/$1/external"
        '';
      };

      restic-backups-synnas = {
        onSuccess = [ "gatus-ok@mail_snc-backup.service" ];
        onFailure = [ "gatus-fail@mail_snc-backup.service" ];
      };

      mail-queue-check = {
        path = [
          config.services.postfix.package
          pkgs.jq
          pkgs.curl
        ];
        serviceConfig = {
          Type = "oneshot";
          EnvironmentFile = config.sops.secrets."services/gatus/env".path;
        };
        script = ''
          stuck=$(postqueue -j | jq -s \
            '[.[] | select(.queue_name == "deferred" and .arrival_time < (now - 3600))] | length')

          if [ "$stuck" -eq 0 ]; then
            ok=true
            err=""
          else
            ok=false
            err="$stuck message(s) deferred for over 1h"
          fi

          curl -fsS --retry 3 -X POST \
            -H "Authorization: Bearer $GATUS_PUSH_TOKEN" \
            --url-query "success=$ok" \
            --url-query "error=$err" \
            "${gatus_url}/api/v1/endpoints/mail_snc-queue/external"
        '';
      };
    };

    systemd.timers = {
      mail-queue-check = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = "*:0/10";
          Persistent = true;
        };
      };
    };
  };
}
