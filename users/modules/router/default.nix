{
  lib,
  config,
  pkgs,
  ...
}:
let
  routercfg = config.modules.router;
in
{
  options = {
    modules.router = {
      enable = lib.mkEnableOption "Enable router";
      interface = lib.mkOption {
        type = lib.types.str;
        default = "enp0s31f6";
      };
    };
  };

  config = lib.mkIf routercfg.enable {
    boot.kernel = {
      sysctl = {
        "net.ipv4.conf.all.forwarding" = true;
        "net.ipv6.conf.all.forwarding" = false;
      };
    };

    networking = {
      nameservers = [ "1.1.1.1" ];
      interfaces = {
        lan = {
          name = routercfg.interface;
          useDHCP = false;
          ipv4.addresses = [
            {
              address = "10.0.200.1";
              prefixLength = 24;
            }
          ];
        };
      };

      nat.enable = false;
      firewall.enable = false;
      nftables = {
        enable = true;
        ruleset = ''
          table inet filter {
            chain output {
              type filter hook output priority 100; policy accept;
            }

            chain input {
              type filter hook input priority filter; policy drop;

              # Allow trusted networks to access the router
              iifname {
                "enp0s31f6",
              } counter accept

              # Allow returning traffic from ppp0 and drop everthing else
              iifname "wlp0s20f3" ct state { established, related } counter accept
              iifname "wlp0s20f3" drop
            }

            chain forward {
              type filter hook forward priority filter; policy drop;

              # Allow trusted network WAN access
              iifname {
                      "enp0s31f6",
              } oifname {
                      "wlp0s20f3",
              } counter accept comment "Allow trusted LAN to WAN"

              # Allow established WAN to return
              iifname {
                      "wlp0s20f3",
              } oifname {
                      "enp0s31f6",
              } ct state established,related counter accept comment "Allow established back to LANs"
            }
          }

          table ip nat {
            chain prerouting {
              type nat hook prerouting priority filter; policy accept;
            }

            # Setup NAT masquerading on the wan interface
            chain postrouting {
              type nat hook postrouting priority filter; policy accept;
              oifname "wlp0s20f3" masquerade
            }
          }
        '';
      };
    };

    environment.systemPackages = with pkgs; [
      tcpdump
      conntrack-tools
    ];

    services.dnsmasq = {
      enable = true;
      settings = {
        server = [ "1.1.1.1" ];
        dhcp-range = [ "10.0.200.50,10.0.200.254" ];
        interface = routercfg.interface;
        dhcp-host = "10.0.200.1";
      };
    };
  };
}
