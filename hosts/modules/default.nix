{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:
{
  imports = [
    ./router
    ./mailserver
    ./sudo
    ./locale
    ./automatic-timezone
    ./remoteBuild
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
    git
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
    command-not-found.enable = true;
  };

  nix.settings.trusted-users = [ "@wheel" ];

  # Each generation add src (/etc/nixos) into it's store.
  # Current system: /nix/var/nix/profiles/system/src/
  system.extraSystemBuilderCmds = "ln -s ${inputs.self.sourceInfo.outPath} $out/src";

  # Add a label with last commit
  # nixos-rebuild list-generations
  system.nixos.label = lib.concatStringsSep "-" (
    (lib.sort (x: y: x < y) config.system.nixos.tags)
    ++ [
      "${config.system.nixos.version}.${
        inputs.self.shortRev or inputs.self.dirtyShortRev or inputs.self.lastModified or "dirty"
      }"
    ]
  );
}
