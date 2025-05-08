{ lib, config, ... }:
let
  automatic-timezonecfg = config.hostModules.automatic-timezone;
in
{
  options = {
    hostModules.automatic-timezone.enable = lib.mkEnableOption "Enable automatic-timezone";
  };

  config = lib.mkIf automatic-timezonecfg.enable {
    services.automatic-timezoned.enable = true;
    services.geoclue2.geoProviderUrl = "https://api.beacondb.net/v1/geolocate";
  };
}
