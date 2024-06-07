{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../shared/global
    ../../users/kodi
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
      #fkms-3d.enable = true;
      #audio.enable = true;
    };
    deviceTree.enable = true;
    pulseaudio.enable = true;
    bluetooth.enable = true;
  };

  programs.dconf.enable = true;

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
            invidious
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
          #autoLogin.timeout = 3;
        };
      };
    };
  };

  system.stateVersion = "23.11";
}
