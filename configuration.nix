# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ pkgs, config, lib, ... }:
let
  home-manager = builtins.fetchTarball
    "https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz";
in {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # (import "${home-manager}/nixos")
    # <home-manager/nixos>
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    # firewall.allowedUDPPorts = [ 51820 ];

    wg-quick.interfaces.bxl-shp = {
      address = [ "10.15.14.3/32" ];
      # listenPort = 51820;
      privateKeyFile = "/etc/wireguard/bxl-shp.key";
      dns = [ "10.15.14.1" ];
      autostart = true;
      peers = [{
        publicKey = "Ft1qUCCs9GkpUfiotZU9Ueq1e9ncXr0PwWEyfLoc6Vs=";
        presharedKeyFile = "/etc/wireguard/bxl-shp.psk";
        #allowedIPs = [ "10.15.14.0/24" "192.168.1.0/24" "91.182.226.236/32" ];
        #allowedIPs = [ "10.15.14.0/24" "192.168.1.0/24" ];
        allowedIPs = [ "0.0.0.0/0" ];
        endpoint = "vpn.bhasher.com:51822";
        persistentKeepalive = 25;
      }];
    };
  };

  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
    #   font = "Lat2-Terminus16";
    keyMap = "fr";
    #   useXkbConfig = true; # use xkb.options in tty.
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable screensharing
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };

  services.xserver = {
    enable = true;
    xkb.layout = "fr";
    displayManager = {
      autoLogin = {
        enable = true;
        user = "bhasher";
      };
      defaultSession = "hyprland";
      sddm = {
        enable = true;
        wayland.enable = true;
        autoNumlock = true;
      };
    };
  };

  # Enable sound.
  sound.enable = true;
  nixpkgs.config.pulseaudio = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;
  nixpkgs.config.allowUnfree = true;
  hardware.enableAllFirmware = true;

  users.defaultUserShell = pkgs.zsh;

  users.users.bhasher = {
    isNormalUser = true;
    initialPassword = "azerty";
    extraGroups = [ "wheel" "audio" ];
    packages = with pkgs; [ tree ];
  };

  security.sudo = {
    enable = true;
    extraRules = [{
      commands = [
        {
          command = "${pkgs.systemd}/bin/systemctl suspend";
          options = [ "NOPASSWD" ];
        }
        {
          command = "${pkgs.systemd}/bin/reboot";
          options = [ "NOPASSWD" ];
        }
        {
          command = "${pkgs.systemd}/bin/poweroff";
          options = [ "NOPASSWD" ];
        }
      ];
    }];
  };

  home-manager = {
    #extraSpecialArgs = { inherit inputs; };
    users = { "bhasher" = import ./home.nix; };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    systemPackages = with pkgs; [
      kitty
      wget
      vim
      vimPlugins.lazy-nvim
      pulseaudio
      tofi
      pavucontrol
      networkmanager
      font-awesome
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
      wl-clipboard
    ];

    sessionVariables = { NIXOS_OZONE_WL = "1"; };
  };

  programs = {
    hyprland.enable = true;
    git.enable = true;
    dconf.enable = true;
    firefox.enable = true;
    zsh.enable = true;
  };

  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball
      "https://github.com/nix-community/NUR/archive/master.tar.gz") {
        inherit pkgs;
      };
  };

  virtualisation.virtualbox.host = {
    enable = true;
    # enableKvm = true;
    addNetworkInterface = true;
  };

  system.stateVersion = "23.11"; # Did you read the comment?

}

