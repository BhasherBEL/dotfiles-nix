{
  lib,
  config,
  ...
}:
let
  cfg = config.hostServices.vaultwarden;
in
{
  options.hostServices.vaultwarden = {
    enable = lib.mkEnableOption "Enable vaultwarden";
    hostname = lib.mkOption {
      type = lib.types.str;
      default = "vault.bhasher.com";
      description = "The hostname for vaultwarden";
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets = {
      "services/vaultwarden/environments" = {
        owner = config.users.users.vaultwarden.name;
        group = config.users.groups.vaultwarden.name;
      };
    };

    services = {
      vaultwarden = {
        enable = true;
        dbBackend = "postgresql";
        environmentFile = config.sops.secrets."services/vaultwarden/environments".path;
        config = {
          domain = "https://vault.bhasher.com";
          signupsAllowed = false;

          rocketAddress = "127.0.0.1";
          rocketPort = 8222;

          smtpHost = "mail.bhasher.com";
          smtpPort = 587;
          smtpFrom = "no-reply@bhasher.com";
          smtpSecurity = "starttls";
          databaseUrl = "postgresql:///vaultwarden";
          logLevel = "error";
        };
      };
      nginx.virtualHosts."${cfg.hostname}" = {
        forceSSL = true;
        enableACME = true;
        locations = {
          "/" = {
            proxyPass = "http://127.0.0.1:8222/";
            recommendedProxySettings = true;
          };
        };
      };
    };

    hostServices = {
      storage.postgresql.access = [ "vaultwarden" ];
    };

  };
}
