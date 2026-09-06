{
  lib,
  config,
  ...
}:
let
  cfg = config.hostServices.xray;
in
{
  options = {
    hostServices.xray = {
      enable = lib.mkEnableOption "Enable Xray service";
      hostname = lib.mkOption {
        type = lib.types.str;
        default = "evpn.bhasher.com";
        description = "The hostname for Xray";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    sops.templates."xray-config.json" = {
      owner = config.users.users.xray.name;
      content = builtins.toJSON {
        log.loglevel = "warning";
        inbounds = [
          {
            tag = "in-tcp";
            port = 51825;
            protocol = "vless";
            settings = {
              clients = [ { id = config.sops.placeholder."services/xray/uuid"; } ];
              decryption = "none";
            };
            streamSettings = {
              network = "tcp";
              security = "none";
            };
          }
          {
            tag = "in-ws";
            port = 3001;
            listen = "127.0.0.1";
            protocol = "vless";
            settings = {
              clients = [ { id = config.sops.placeholder."services/xray/uuid"; } ];
              decryption = "none";
            };
            streamSettings = {
              network = "ws";
              security = "none";
              wsSettings.path = "/vless-ws";
            };
          }
          {
            tag = "in-grpc";
            port = 3002;
            listen = "127.0.0.1";
            protocol = "vless";
            settings = {
              clients = [ { id = config.sops.placeholder."services/xray/uuid"; } ];
              decryption = "none";
            };
            streamSettings = {
              network = "grpc";
              security = "none";
              grpcSettings.serviceName = "vless-grpc";
            };
          }
        ];
        outbounds = [
          {
            tag = "direct";
            protocol = "freedom";
          }
        ];
        routing.rules = [
          {
            type = "field";
            inboundTag = [
              "in-tcp"
              "in-ws"
              "in-grpc"
            ];
            outboundTag = "direct";
          }
        ];
      };
    };

    users = {
      users.users.xray = {
        isSystemUser = true;
        group = "xray";
      };
      groups.xray = { };
    };

    services = {
      xray = {
        enable = true;
        # services.settingsFile = config.sops.templates."xray-config.json".path;
      };
      nginx.virtualHosts.${cfg.hostname} = {
        forceSSL = true;
        enableACME = true;
        locations = {
          "/vless-ws" = {
            proxyPass = "http://127.0.0.1:3001";
            recommendedProxySettings = true;
            proxyWebsockets = true;
          };
          "/vless-grpc" = {
            extraConfig = ''
              grpc_pass grpc://127.0.0.1:3002";
              grpc_set_header Host $host;
              grpc_read_timeout 86400s;
            '';
          };
        };
        extraConfig = "http2 on;";
      };
    };

    networking.firewall.allowedTCPPorts = [ 51825 ];
  };
}
