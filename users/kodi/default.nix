{ config, pkgs, ... }:
let
  cifsOptions = [
    "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,credentials=/run/secrets/smb/truenas,uid=1002,gid=100"
  ];
in
{
  imports = [ ../optional/bluetooth.nix ];

  home-manager.users.kodi = import ../../home/kodi.nix;

  sops = {
    defaultSopsFile = ../../secrets/bhasher.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/etc/nixos/keys/bhasher.txt";
    secrets = {
      "smb/truenas" = {
        owner = config.users.users.kodi.name;
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

  environment.systemPackages = with pkgs; [ zsh-powerlevel10k ];

  fileSystems."/mnt/movies" = {
    device = "//192.168.1.201/movies";
    fsType = "cifs";
    options = cifsOptions;
  };
  fileSystems."/mnt/music" = {
    device = "//192.168.1.201/brieuc/SyncDocuments/music";
    fsType = "cifs";
    options = cifsOptions;
  };
}
