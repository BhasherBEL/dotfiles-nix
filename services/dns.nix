{ lib, config, ... }:
{
  options = {
    hostServices.dns = {
      enable = lib.mkEnableOption "Enable DNS";
      mappings = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
      };
    };
  };

  config = lib.mkIf config.hostServices.dns.enable {
    services = {
      blocky = {
        enable = true;
        settings = {
          minTlsServeVersion = 1.2;
          connectIPVersion = "v4";
          ports.dns = 53;
          log.level = "warn";
          upstreams = {
            strategy = "strict";
            groups.default = [
              "127.0.0.1:5335"
              "https://unfiltered.joindns4.eu/dns-query"
              "https://one.one.one.one/dns-query"
            ];
          };
          bootstrapDns = [
            "1.1.1.1"
            "1.0.0.1"
            "86.54.11.100"
            "86.54.11.200"
          ];
          filtering = {
            queryTypes = [
              "AAAA"
            ];
          };
          customDNS.mapping = config.hostServices.dns.mappings;
          blocking = {
            denylists = {
              ads = [
                "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
              ];
            };
            clientGroupsBlock = {
              default = [ "ads" ];
            };
          };
        };
      };

      unbound = {
        enable = true;
        settings = {
          server = {
            verbosity = 0;
            interface = [ "127.0.0.1" ];
            port = 5335;
            access-control = [ "127.0.0.1 allow" ];
            do-ip4 = true;
            do-ip6 = false;
            do-udp = true;
            do-tcp = true;

            harden-glue = true;
            harden-dnssec-stripped = true;
            use-caps-for-id = false;
            prefetch = true;
            edns-buffer-size = 1232;
            hide-identity = true;
            hide-version = true;

            private-address = [
              "192.168.0.0/16"
              "169.254.0.0/16"
              "172.16.0.0/12"
              "10.0.0.0/8"
              "192.0.2.0/24"
              "198.51.100.0/24"
              "203.0.113.0/24"
              "255.255.255.255/32"
            ];
          };
        };
      };
    };

    networking.firewall.allowedUDPPorts = [
      53
    ];
  };
}
