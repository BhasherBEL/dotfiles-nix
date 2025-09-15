{ config, pkgs, ... }:
let
  cifsOptions = [
    "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,credentials=/run/secrets/smb/truenas,uid=1002,gid=100"
  ];
in
{
  home-manager.users.kodi = import ../../home/kodi.nix;

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
      "ssh/oa-fw" = {
        owner = config.users.users.kodi.name;
      };
      "security/u2f_keys" = {
        owner = config.users.users.kodi.name;
        mode = "0400";
        path = "${config.users.users.kodi.home}/.config/Yubico/u2f_keys";
      };
    };
  };

  users.users.kodi = {
    isNormalUser = true;
    initialPassword = "raspberry";
    extraGroups = [
      "wheel"
      "audio"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOGsCS7XysWiFuLVmN01cJAAZN2ZhWVB4V6R6F5DLsuM"
    ];
  };

  nix.settings.trusted-users = [ "kodi" ];

  networking.firewall = {
    allowedTCPPorts = [ 8080 ];
    allowedUDPPorts = [ 8080 ];
  };
}
