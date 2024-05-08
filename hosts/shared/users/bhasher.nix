{ pkgs, config, ... }:
let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
  cifsOptions = [
    "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,credentials=/run/secrets/smb/truenas,uid=1000,gid=100"
  ];
in
{
  imports = [
    ../optional/python.nix
    ../optional/languagelab.nix
    ../optional/docker.nix
    ../optional/virtualbox.nix
    ../optional/js.nix
    ../optional/java.nix
    # Not working, probably related to https://github.com/rustdesk/rustdesk/issues/3565
    ../optional/rustdesk.nix
    ../optional/media.nix
    ../optional/vscodium.nix
  ];

  sops = {
    defaultSopsFile = ../../../secrets/bhasher.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/etc/nixos/keys/bhasher.txt";
    secrets = {
      "smb/truenas" = {
        owner = config.users.users.bhasher.name;
      };
      "ssh/snodes" = {
        owner = config.users.users.bhasher.name;
      };
    };
  };

  home-manager.users.bhasher = import ../../../home/bhasher.nix;

  media.jellyfin = true;

  users.users.bhasher = {
    isNormalUser = true;
    initialPassword = "azerty";
    extraGroups =
      [
        "wheel"
        "audio"
      ]
      ++ ifTheyExist [
        "docker"
        "wireshark"
        "uucpd"
      ];
  };

  fileSystems."/mnt/brieuc" = {
    device = "//192.168.1.201/brieuc";
    fsType = "cifs";
    options = cifsOptions;
  };
  fileSystems."/mnt/commun" = {
    device = "//192.168.1.201/commun";
    fsType = "cifs";
    options = cifsOptions;
  };
  fileSystems."/mnt/photos" = {
    device = "//192.168.1.201/photos";
    fsType = "cifs";
    options = cifsOptions;
  };
  fileSystems."/mnt/movies" = {
    device = "//192.168.1.201/movies";
    fsType = "cifs";
    options = cifsOptions;
  };

  environment.systemPackages = with pkgs; [
    tree
    freetube
    signal-desktop
    ferdium
    thunderbird
    asciinema
    onlyoffice-bin
    sl
    ranger
    obs-studio
    yt-dlp
    spotdl
    joplin
  ];

  programs.kdeconnect.enable = true;
}
