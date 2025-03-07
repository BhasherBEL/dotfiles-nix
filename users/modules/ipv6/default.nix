{ lib, config, ... }:
let
  ipv6cfg = config.modules.ipv6;
in
{
  options = {
    modules.ipv6.disable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Disable IPv6 globally on the system.";
    };
  };

  config = lib.mkIf ipv6cfg.disable {
    networking.enableIPv6 = false;
    boot.kernel.sysctl = {
      "net.ipv6.conf.all.disable_ipv6" = 1;
      "net.ipv6.conf.default.disable_ipv6" = 1;
      "net.ipv6.conf.lo.disable_ipv6" = 1;
    };
  };
}
