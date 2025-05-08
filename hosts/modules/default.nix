{ pkgs, lib, ... }:
{
  imports = [
    ./router
    ./mailserver
    ./sudo
    ./locale
    ./automatic-timezone
  ];

  hostModules = {
    sudo.enable = true;
    locale.enable = true;
    automatic-timezone.enable = true;
  };

  boot.tmp.cleanOnBoot = lib.mkDefault true;

  # Should fix the issue with the screen not turning on after suspend
  systemd.sleep.extraConfig = "HibernateMode=shutdown\nHibernateDelaySec=20m";

  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    optimise.automatic = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  networking.networkmanager.enable = true;

  users.defaultUserShell = pkgs.zsh;

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "gaoptout"
      "android-sdk-cmdline-tools"
      "android-sdk-tools"
      "android-studio-stable"
      "mqtt-explorer" # CC-BY-NC-4.0
    ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  # Modulize this

  environment.systemPackages = with pkgs; [
    wget
    vim
    vimPlugins.lazy-nvim
    networkmanager
    font-awesome
    zip
    mdcat
    dnsutils
    xorg.xlsclients
    font-awesome
    sops
    openssl
    unzip
    ripgrep
    killall
  ];

  programs = {
    dconf.enable = true;
    zsh.enable = true;
  };
}
