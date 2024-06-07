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
    ../optional/js.nix
    ../optional/media.nix
    ../optional/bluetooth.nix
    ../optional/yubikey.nix
  ];
  home-manager.users.bhasher.imports = [ ../../home/bhasher.nix ];

  sops = {
    defaultSopsFile = ../../secrets/bhasher.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/etc/nixos/keys/bhasher.txt";
    secrets = {
      "smb/truenas" = {
        owner = config.users.users.bhasher.name;
      };
      "ssh/snodes" = {
        owner = config.users.users.bhasher.name;
      };
      "ssh/gitkey" = {
        owner = config.users.users.bhasher.name;
      };
      "ssh/languagelab" = {
        owner = config.users.users.bhasher.name;
      };
      "ssh/gitea" = {
        owner = config.users.users.bhasher.name;
      };
      "ssh/llnux" = {
        owner = config.users.users.bhasher.name;
      };
      "api/mistral" = {
        owner = config.users.users.bhasher.name;
      };
      "security/u2f_keys" = {
        owner = config.users.users.bhasher.name;
        mode = "0400";
        path = "${config.users.users.bhasher.home}/.config/Yubico/u2f_keys";
      };
    };
  };

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
    yt-dlp
    spotdl
    joplin
    marksman
    nmap
    yubikey-manager
    pam_u2f
  ];

  # TODO: fix
  # error activating kdeconnectd: QDBusError("org.freedesktop.DBus.Error.Spawn.ChildSignaled", "Process org.kde.kdeconnect received signal 6")
  # error: Process org.kde.kdeconnect received signal 6
  programs.kdeconnect = {
    enable = true;
    package = pkgs.libsForQt5.kdeconnect-kde.overrideAttrs (old: {
      buildFromSource = true;
      buildInputs = old.buildInputs ++ [ pkgs.qt5.qttools ];
      NIX_CFLAGS_COMPILE = "-DCMAKE_VERBOSE_MAKEFILE=ON";
    });
  };

  hardware.printers = {
    ensurePrinters = [
      {
        name = "Lexmark-N&B-kot";
        location = "kot";
        deviceUri = "dnssd://Lexmark%20MS510dn%20(3)._ipp._tcp.local/?uuid=bb9f86e6-3117-4c3c-9297-a5923efbc4e1";
        model = "drv:///sample.drv/generic.ppd";
        # TODO: fix
        #ppdOptions = {
        #  PageSize = "A4";
        #  sides = "two-sided-long-edge";
        #};
      }
    ];
    ensureDefaultPrinter = "Lexmark-N&B-kot";
  };

  # TODO: TEMPORARY
  networking.firewall = {
    enable = false;
    allowedTCPPorts = [
      10001
      10002
    ];
    allowedUDPPorts = [
      10001
      10002
    ];
  };

  services.pipewire.extraConfig.pipewire = {
    "99-roc-source" = {
      context = {
        modules = {
          name = "libpipewire-module-roc-source";
          args = {
            fec.code = "rs8m";
            source = {
              name = "ROC source";
              props.node.name = "ROC source";
            };
            local = {
              ip = "0.0.0.0";
              source.port = 10001;
              repair.port = 10002;
            };
          };
        };
      };
    };
    "99-roc-sink" = {
      context = {
        modules = {
          name = "libpipewire-module-roc-sink";
          args = {
            fec.code = "rs8m";
            sink = {
              name = "ROC sink";
              props.node.name = "ROC sink";
            };
            remote = {
              ip = "10.0.1.6";
              source.port = 10001;
              repair.port = 10002;
            };
          };
        };
      };
    };
  };
}
