{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    # Not working
    # ./disk-config.nix
  ];

  networking.hostName = "media-center";

  hardware = {
    raspberry-pi."4" = {
      apply-overlays-dtmerge.enable = true;
      fkms-3d.enable = true;
      #audio.enable = true;
      bluetooth.enable = true;
    };
    deviceTree.enable = true;
    #pulseaudio.enable = true;
    bluetooth.enable = true;
  };

  programs.dconf.enable = true;

  services = {
    openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
    };

    # xserver = {
    #   enable = true;
    #   desktopManager.kodi = {
    #     enable = true;
    #     package = pkgs.kodi.withPackages (
    #       p: with p; [
    #         jellyfin
    #         netflix
    #         invidious
    #         arteplussept
    #         sponsorblock
    #         inputstreamhelper
    #         youtube
    #       ]
    #     );
    #   };
    #
    #   displayManager.lightdm.enable = true;
    # };

    displayManager = {
      autoLogin = {
        enable = true;
        user = "kodi";
      };
    };
  };

  environment = {
    systemPackages = with pkgs; [
      raspberrypi-eeprom
    ];
    persistence."/persistent" = {
      enable = true;
      hideMounts = true;
      directories = [
        #Mandatory https://github.com/NixOS/nixpkgs/pull/273384
        "/var/lib/nixos"
        "/etc/nixos"
        #To prevent builds to fill all remaining space
        "/tmp"
        "/var/tmp"
        #TODO: Find a nix way?
        "/etc/NetworkManager/system-connections"
        "/var/lib/iwd"
        {
          directory = "/etc/ssh/";
          mode = "0700";
        }
        "/run/secrets.d"
      ];
      files = [ "/var/lib/alsa/asound.state" ];
      users.kodi = {
        #directories = [ ".kodi" ];
      };

    };
  };

  system.stateVersion = "25.05";
}
