{ config, ... }:
{
  sops = {
    defaultSopsFile = ../../secrets/bhasher.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/persistent/etc/nixos/keys/bhasher.txt";
    secrets = {
      "smb/truenas" = {
        owner = config.users.users.kodi.name;
      };
      "ssh/gitkey" = {
        owner = config.users.users.kodi.name;
      };
    };
  };

  users.users.spi = {
    isNormalUser = true;
    initialPassword = "spi";
    extraGroups = [
      "wheel"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOGsCS7XysWiFuLVmN01cJAAZN2ZhWVB4V6R6F5DLsuM"
    ];
  };
}
