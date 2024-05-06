{ pkgs, ... }:
{
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
}
