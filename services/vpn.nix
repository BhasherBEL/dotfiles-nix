{
  lib,
  config,
  ...
}:
{
  options = {
    hostServices.vpn = {
      enable = lib.mkEnableOption "Enable VPN service";
      interface = lib.mkOption {
        type = lib.types.str;
        default = "eno1";
        description = "VPN interface name";
      };
    };
  };

  config = lib.mkIf config.hostServices.vpn.enable {
    sops.secrets = {
      "wg/bxl-shp/server/key" = {
        mode = "640";
      };
    };

    networking = {
      nat = {
        enable = true;
        enableIPv6 = true;
        externalInterface = config.hostServices.vpn.interface;
        internalInterfaces = [ "wg0" ];
      };

      wg-quick.interfaces = {
        wg0 = {
          address = [
            "10.20.0.1/24"
            "fd8c:70ee:bdd8:1:1::1/64"
          ];
          dns = lib.mkIf config.hostServices.dns.enable [ "127.0.0.1" ];
          listenPort = 51824;
          privateKeyFile = "/run/secrets/wg/bxl-shp/server/key";
          peers = [
            {
              # Phone
              publicKey = "6TBTGMlvTenljGf71gewKSiDmhGCfG4b+giN853tHyU=";
              allowedIPs = [
                "10.20.0.2/32"
                "fd8c:70ee:bdd8:0:1::2/128"
              ];
            }
            {
              # Laptop
              publicKey = "46829GHQ4IoMsRlpBo076dCWxmPnAWCfnBOriKxIYXQ=";
              allowedIPs = [
                "10.20.0.3/32"
                "fd8c:70ee:bdd8:0:1::3/128"
              ];
            }
            {
              # Desktop
              publicKey = "zHMdwCTF1h9D0wTD5Gfk1aM9WBtib8FMGgG7E5sihB0=";
              allowedIPs = [
                "10.20.0.4/32"
                "fd8c:70ee:bdd8:1:1::2/128"
              ];
            }
            {
              # spi
              publicKey = "3mXQbotJ/ZDogkRdgX5x7wCrk2Jw3RsMHSWH0PYMRn0=";
              allowedIPs = [
                "10.20.0.5/32"
                "fd8c:70ee:bdd8:2:1::1/128"
                "192.168.1.0/24"
                "192.168.10.0/24"
              ];
            }
            {
              # mikrotik
              publicKey = "oYkq7VeUdY5GTMixS/sGGs68hXRLMA7ABm1fpPkUDU8=";
              endpoint = "vpn.bxl.bhasher.com:51825";
              persistentKeepalive = 25;
              allowedIPs = [
                "10.20.0.6/32"
                "fd8c:70ee:bdd8:2:1::2/128"
              ];
            }
            {
              # media-center
              publicKey = "5D63LPzlmoj8rGxoWXNcu7zb/WauUMEcwAnVBKQmQnY=";
              allowedIPs = [
                "10.20.0.7/32"
                "fd8c:70ee:bdd8:1:1::3/128"
              ];
            }
            {
              # dad's laptop
              publicKey = "YJrML0wO2lbimQD661d4Suq5kmVTgbYIlDj0fvtpVnQ=";
              allowedIPs = [
                "10.20.0.8/32"
                "fd8c:70ee:bdd8:2:2::2/128"
              ];
            }
          ];

          # postUp = ''
          #   ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -j ACCEPT
          #   ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.20.0.1/24 -o ${config.hostServices.vpn.interface} -j MASQUERADE
          #   ${pkgs.iptables}/bin/ip6tables -A FORWARD -i wg0 -j ACCEPT
          #   ${pkgs.iptables}/bin/ip6tables -t nat -A POSTROUTING -s fd31:bf08:57cb::1/64 -o ${config.hostServices.vpn.interface} -j MASQUERADE
          # '';
          #
          # preDown = ''
          #   ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -j ACCEPT
          #   ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.20.0.1/24 -o ${config.hostServices.vpn.interface} -j MASQUERADE
          #   ${pkgs.iptables}/bin/ip6tables -D FORWARD -i wg0 -j ACCEPT
          #   ${pkgs.iptables}/bin/ip6tables -t nat -D POSTROUTING -s fd31:bf08:57cb::1/64 -o ${config.hostServices.vpn.interface} -j MASQUERADE
          # '';
        };
      };

      firewall.allowedUDPPorts = [ 51824 ];
    };

    systemd.services.wg-quick-wg0.serviceConfig = lib.mkIf config.hostServices.dns.enable {
      After = [
        "network-online.target"
        "blocky.service"
      ];
      Wants = [
        "network-online.target"
        "blocky.service"
      ];
      Restart = "on-failure";
      RestartSec = 5;
      StartLimitIntervalSec = 0;
    };

  };
}
