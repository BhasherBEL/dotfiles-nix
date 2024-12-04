{ pkgs, ... }:
{
  programs.openvpn3 = {
    enable = true;
    log-service.settings.log_level = 6;
    netcfg.settings.systemd_resolved = true;
  };

  services.resolved.enable = true;

  environment.systemPackages = with pkgs; [
    python311Packages.uvicorn
    sqlitebrowser
  ];
}
