{
  pkgs,
  inputs,
  lib,
  homeModules,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
  ];

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

  time.timeZone = "Europe/Paris";

  i18n = {
    supportedLocales = [
      "fr_FR.UTF-8/UTF-8"
      "en_GB.UTF-8/UTF-8"
    ];
    defaultLocale = "en_GB.UTF-8";
    extraLocaleSettings = {
      LC_NUMERIC = "fr_FR.UTF-8";
      LC_MONETARY = "fr_FR.UTF-8";
    };
  };

  console.keyMap = "fr";

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
    extraSpecialArgs = {
      inherit homeModules;
    };
  };

  security.sudo = {
    enable = true;
    extraRules = [
      {
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
      }
    ];
  };

  environment.systemPackages = with pkgs; [
    wget
    vim
    vimPlugins.lazy-nvim
    networkmanager
    font-awesome
    #stylua
    #prettierd
    #nil
    #gcc
    #ltex-ls
    zip
    mdcat
    dnsutils
    #clang-tools_17
    xorg.xlsclients
    font-awesome
    #zsh-powerlevel10k
    sops
    openssl
    unzip
    #lua-language-server
    ripgrep
    killall
  ];

  programs = {
    git.enable = true;
    zsh = {
      enable = true;
      shellAliases = {
        nb = "echo \"nixos-rebuild switch --flake /etc/nixos#$(hostname) --use-remote-sudo\" && nixos-rebuild switch --flake /etc/nixos#$(hostname) --use-remote-sudo";
        nbo = "echo \"Offline build\" && echo \"nixos-rebuild switch --flake /etc/nixos#$(hostname) --use-remote-sudo\" && nixos-rebuild switch --flake /etc/nixos#$(hostname) --use-remote-sudo --option substitute false";
        ncc = "echo \"sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d && nix-collect-garbage -d\" && sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d && nix-collect-garbage -d";
        ns = "SOPS_AGE_KEY_FILE=/etc/nixos/keys/$USER.txt sops";
        nu = "nix flake update --flake /etc/nixos";
      };
    };
    dconf.enable = true;
  };
}
