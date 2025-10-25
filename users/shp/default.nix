{ config, ... }:
{
  home-manager.users.shp.imports = [ ../../home/shp.nix ];

  nix.settings.trusted-users = [ "shp" ];

  sops = {
    defaultSopsFile = ../../secrets/bhasher.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/persistent/etc/nixos/keys/bhasher.txt";
    secrets = {
      "ssh/gitkey" = {
        owner = config.users.users.shp.name;
      };
    };
  };

  users.users.shp = {
    isNormalUser = true;
    initialPassword = "raspberry";
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOGsCS7XysWiFuLVmN01cJAAZN2ZhWVB4V6R6F5DLsuM"
    ];
  };
}
