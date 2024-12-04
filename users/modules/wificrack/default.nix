{
  pkgs,
  lib,
  config,
  ...
}:
let
  wificrackcfg = config.modules.wificrack;
in
{
  options = {
    modules.wificrack.enable = lib.mkEnableOption "Enable wificrack";
  };

  config = lib.mkIf wificrackcfg.enable {
    environment.systemPackages = with pkgs; [ wifite2 ];

    #home.file."rockyou" = fetchTarball {
    #  url = "https://github.com/zacheller/rockyou/raw/master/rockyou.txt.tar.gz";
    #  sha256 = "47c070a029bcdb4cbd0e02c69fed136ef46dce4048ddbadf177daa5e885b8172";
    #};

    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-compute-runtime
        intel-media-driver
      ];
    };
  };
}
