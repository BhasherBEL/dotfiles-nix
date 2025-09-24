{
  lib,
  config,
  ...
}:
let
  cfg = config.hostServices.vpn-client;
in
{
  options = {
    hostServices.vpn-client = {
      enable = lib.mkEnableOption "Enable VPN client";
      ipv4 = lib.mkOption {
        type = lib.types.str;
        description = "IPv4 address for the VPN client. usually 10.20.0.x/32";
      };
      ipv6 = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "IPv6 address for the VPN client (optional) Usually fd8c:70ee:bdd8:x:y::z/128";
      };
      privateKeySecret = lib.mkOption {
        type = lib.types.str;
        description = "Relative path of the private key secret for the VPN client.";
      };
      routeAll = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Route all traffic through the VPN";
      };
      routeLan = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Route LAN traffic through the VPN";
      };
      autostart = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to autostart the VPN connection on boot.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets = {
      "${cfg.privateKeySecret}" = {
        mode = "640";
      };
    };

    networking = {
      nat = {
        enable = true;
        enableIPv6 = cfg.ipv6 != null;
        internalInterfaces = [ "wg0" ];
      };

      wg-quick.interfaces = {
        wg0 = {
          address = lib.filter (x: x != null) [
            cfg.ipv4
            cfg.ipv6
          ];
          dns = [ "10.20.0.1" ];
          privateKeyFile = "/run/secrets/${cfg.privateKeySecret}";
          autostart = cfg.autostart;
          peers = [
            {
              # SHP
              publicKey = "Ft1qUCCs9GkpUfiotZU9Ueq1e9ncXr0PwWEyfLoc6Vs=";
              endpoint = "vpn.wol.bhasher.com:51824";
              allowedIPs =
                if cfg.routeAll then
                  [
                    "0.0.0.0/0"
                  ]
                else
                  [
                    "10.20.0.0/24"
                    "fd8c:70ee:bdd8::/64"
                  ]
                  ++ lib.optional cfg.routeLan [
                    "192.168.0.0/24"
                  ];
            }
          ];
        };
      };
    };
  };
}
