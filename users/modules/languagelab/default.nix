{
  pkgs,
  lib,
  config,
  ...
}:
let
  languagelabcfg = config.modules.languagelab;
in
{
  options = {
    modules.languagelab.enable = lib.mkEnableOption "Enable languagelab";
  };

  config = lib.mkIf languagelabcfg.enable {
    programs.openvpn3 = {
      enable = true;
      log-service.settings.log_level = 6;
      netcfg.settings.systemd_resolved = true;
    };

    services.resolved.enable = false;

    environment.systemPackages = with pkgs; [
      python311Packages.uvicorn
      sqlitebrowser
    ];

    modules = {
      js.enable = true;
      python.enable = true;
    };
  };
}
