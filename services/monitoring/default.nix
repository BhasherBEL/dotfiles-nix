{ lib, config, ... }:
let
  monitoringcfg = config.hostServices.monitoring;
in
{
  imports = [
    ./grafana.nix
    ./prometheus.nix
  ];

  options = {
    hostServices.monitoring.enable = lib.mkEnableOption "Enable monitoring";
  };

  config = lib.mkIf monitoringcfg.enable {
    hostServices = {
      nginx.enable = true;

      monitoring = {
        prometheus.enable = lib.mkDefault true;
        grafana.enable = lib.mkDefault true;
      };
    };

  };
}
