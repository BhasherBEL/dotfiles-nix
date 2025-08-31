{ config, ... }:
{
  home-manager.users.spi = import ../../home/spi.nix;

  sops = {
    defaultSopsFile = ../../secrets/bhasher.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/persistent/etc/nixos/keys/bhasher.txt";
    secrets = {
      "ssh/gitkey" = {
        owner = config.users.users.spi.name;
      };
    };
  };

  users.users.spi = {
    isNormalUser = true;
    initialPassword = "raspberry";
    extraGroups = [
      "wheel"
        "networkmanager"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOGsCS7XysWiFuLVmN01cJAAZN2ZhWVB4V6R6F5DLsuM"
    ];
  };
}
