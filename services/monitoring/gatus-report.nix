{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.hostServices.monitoring.gatus-report;
in
{
  options = {
    hostServices.monitoring.gatus-report = {
      enable = lib.mkEnableOption "Enable gatus report services";
      url = lib.mkOption {
        type = lib.types.str;
        default = "http://10.20.0.1:61303";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets."services/gatus/env" = { };

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
            "${cfg.url}/api/v1/endpoints/$1/external"
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
            "${cfg.url}/api/v1/endpoints/$1/external"
        '';
      };
    };
  };
}
