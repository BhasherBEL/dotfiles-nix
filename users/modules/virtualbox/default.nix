{
  pkgs,
  lib,
  config,
  ...
}:
let
  virtualboxcfg = config.modules.virtualbox;
in
{
  options = {
    modules.virtualbox.enable = lib.mkEnableOption "Enable virtualbox";
  };

  config = lib.mkIf virtualboxcfg.enable {
    virtualisation.virtualbox.host = {
      enable = true;
      addNetworkInterface = true;
    };

    programs.wireshark.enable = true;

    environment.systemPackages = with pkgs; [ wireshark ];

    services.vsftpd = {
      enable = true;
      writeEnable = false;
      localUsers = true;
      userlist = [ "bhasher" ];
      userlistEnable = true;
    };
  };
}
