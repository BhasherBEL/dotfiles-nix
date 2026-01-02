{ pkgs, config, ... }:
let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
  cifsOptions = [
    "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,credentials=/run/secrets/smb/truenas,uid=1000,gid=100"
  ];
in
{
  home-manager.users.bhasher.imports = [ ../../home/bhasher ];

  nix.settings.trusted-users = [ "bhasher" ];

  services.greetd.settings.default_session.user = "bhasher";

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
      "ssh/ovh_vps" = {
        owner = config.users.users.bhasher.name;
      };
      "ssh/oa-fw" = {
        owner = config.users.users.bhasher.name;
      };
      "api/mistral" = {
        owner = config.users.users.bhasher.name;
      };
      "api/chatgpt" = {
        owner = config.users.users.bhasher.name;
      };
      "api/anthropic" = {
        owner = config.users.users.bhasher.name;
      };
      "api/github" = {
        owner = config.users.users.bhasher.name;
      };
      "security/u2f_keys" = {
        owner = config.users.users.bhasher.name;
        mode = "0400";
        path = "${config.users.users.bhasher.home}/.config/Yubico/u2f_keys";
      };
    };
  };

  users.users.bhasher = {
    isNormalUser = true;
    initialPassword = "azerty";
    extraGroups = [
      "wheel"
      "audio"
      "networkmanager"
    ]
    ++ ifTheyExist [
      "docker"
      "wireshark"
      "uucpd"
      "kvm"
      "adbusers"
      "dialout"
      "openvpn"
      "plugdev"
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
    signal-desktop-bin
    thunderbird
    libreoffice-fresh
    sl
    yt-dlp
    marksman
    nmap
    vlc
    pinentry-curses
    qdirstat
    sieve-editor-gui
    sqlitebrowser
  ];

  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-curses;
    enableSSHSupport = true;
  };
  # Required by hyprlock for fingerprint authentication
  services.fprintd.enable = true;

  # TODO: fix
  # error activating kdeconnectd: QDBusError("org.freedesktop.DBus.Error.Spawn.ChildSignaled", "Process org.kde.kdeconnect received signal 6")
  # error: Process org.kde.kdeconnect received signal 6
  programs = {
    kdeconnect = {
      enable = false;
      package = pkgs.libsForQt5.kdeconnect-kde.overrideAttrs (old: {
        buildFromSource = true;
        buildInputs = old.buildInputs ++ [ pkgs.qt5.qttools ];
        NIX_CFLAGS_COMPILE = "-DCMAKE_VERBOSE_MAKEFILE=ON";
      });
    };
  };

  hardware.printers = {
    ensurePrinters = [
      {
        name = "Lexmark-N&B-home";
        location = "living room";
        deviceUri = "dnssd://Lexmark%20MS510dn%20(3)._ipp._tcp.local/?uuid=bb9f86e6-3117-4c3c-9297-a5923efbc4e1";
        model = "drv:///sample.drv/generic.ppd";
        ppdOptions = {
          PageSize = "A4";
          Duplex = "DuplexNoTumble";
          Option1 = "True";
        };
      }
    ];
    ensureDefaultPrinter = "Lexmark-N&B-home";
  };

  modules = {
    metaPc.enable = true;
    devenv.enable = true;
    docker.enable = true;
    # Until https://github.com/NixOS/nixpkgs/issues/437865 is resolved
    jellyfin-media-player.enable = false;
  };
}
