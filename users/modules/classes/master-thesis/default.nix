{
  lib,
  config,
  pkgs,
  ...
}:
let
  master-thesiscfg = config.modules.classes.master-thesis;
in
{
  options = {
    modules.classes.master-thesis = {
      enable = lib.mkEnableOption "Enable master-thesis";
      iface = lib.mkOption {
        type = lib.types.str;
        description = "Wi-Fi network interface to use";
      };
    };
  };

  config = lib.mkIf master-thesiscfg.enable {
    environment.systemPackages = with pkgs; [
      zotero
      brave
      mqtt-explorer
      arduino-language-server
      arduino-cli
      clang-tools
    ];

    services = {
      create_ap = {
        enable = true;
        settings = {
          WIFI_IFACE = "wlp0s20f3";
          INTERNET_IFACE = "enp0s31f6";
          SSID = "Thesis-IoT";
          PASSPHRASE = "MasterThesis2025ESP";
          FREQ_BAND = "2.4";
        };
      };
      haveged.enable = true;
      mosquitto = {
        enable = true;
        listeners = [
          {
            users.esp32 = {
              acl = [
                "readwrite #"
              ];
              hashedPassword = "$7$101$joqZ202feP0REk69$UZ5Tfn4l3wLwVhS2qifMbZjcFiyMoIYddHymLsQNc+RHxjf5Ut7xM9unwohoeFTJYcNY9xTkoUDUpLcEvmiwqA==";
            };
          }
        ];
      };
    };

    networking = {
      firewall.allowedTCPPorts = [
        53
        67
        1883
      ];
    };
  };
}
