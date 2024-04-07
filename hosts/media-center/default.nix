{ pkgs, ... }:
let
  cifsOptions = [
    "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,credentials=/etc/nixos/secrets/.smb,uid=1002,gid=100"
  ];
in
{
  imports = [
    ./hardware-configuration.nix
    ../shared/global
    ../shared/users/kodi.nix
    ../shared/optional/bluetooth.nix
  ];

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  networking = {
    hostName = "media-center";
    dhcpcd.enable = true;
    interfaces.end0 = {
      ipv4.addresses = [
        {
          address = "10.0.0.10";
          prefixLength = 23;
        }
      ];
      wakeOnLan.enable = true;
    };
    defaultGateway = "10.0.0.1";
    nameservers = [ "10.0.0.1" ];
    firewall = {
      allowedTCPPorts = [ 8080 ];
      allowedUDPPorts = [ 8080 ];
    };

    wg-quick.interfaces.bxl-shp = {
      address = [ "10.15.14.5/32" ];
      privateKeyFile = "/etc/wireguard/bxl-shp.key";
      dns = [ "10.15.14.1" ];
      autostart = true;
      peers = [
        {
          publicKey = "Ft1qUCCs9GkpUfiotZU9Ueq1e9ncXr0PwWEyfLoc6Vs=";
          presharedKeyFile = "/etc/wireguard/bxl-shp.psk";
          allowedIPs = [ "0.0.0.0/0" ];
          endpoint = "vpn.bhasher.com:51822";
          persistentKeepalive = 25;
        }
      ];
    };
  };

  hardware = {
    raspberry-pi."4" = {
      apply-overlays-dtmerge.enable = true;
      fkms-3d.enable = true;
      #audio.enable = true;
    };
    deviceTree.enable = true;
  };

  services = {
    openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
    };

    xserver = {
      enable = true;
      desktopManager.kodi = {
        enable = true;
        package = pkgs.kodi.withPackages (
          p: with p; [
            jellyfin
            netflix
            youtube
            arteplussept
            sponsorblock
            inputstreamhelper
          ]
        );
      };
      displayManager = {
        autoLogin = {
          enable = true;
          user = "kodi";
        };
        lightdm = {
          enable = true;
          autoLogin.timeout = 3;
        };
      };
    };
  };

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

  system.stateVersion = "23.11";
}
