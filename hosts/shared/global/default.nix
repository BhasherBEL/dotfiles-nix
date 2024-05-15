{
  pkgs,
  inputs,
  lib,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
  ];

  boot.tmp.cleanOnBoot = lib.mkDefault true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  time.timeZone = "Europe/Paris";

  # Internationalisation settings
  i18n.defaultLocale = "en_GB.UTF-8";
  console.keyMap = "fr";

  networking.networkmanager.enable = true;

  users.defaultUserShell = pkgs.zsh;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
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
    stylua
    nixfmt-rfc-style
    prettierd
    nil
    gcc
    ltex-ls
    zip
    mdcat
    dnsutils
    clang-tools_17
    xorg.xlsclients
    font-awesome
    zsh-powerlevel10k
    sops
    openssl
    unzip
    lua-language-server
    ripgrep
  ];

  programs = {
    git.enable = true;
    zsh = {
      enable = true;
      shellAliases = {
        nb = "echo \"sudo nixos-rebuild switch --flake /etc/nixos#$(hostname)\" && sudo nixos-rebuild switch --flake /etc/nixos#$(hostname)";
        #nb = "echo \"sudo nixos-rebuild switch --flake /home/bhasher/sync/nixos#$(hostname)\" && sudo nixos-rebuild switch --flake /home/bhasher/sync/nixos#$(hostname)";
        ncc = "echo \"nix-collect-garbage -d\" && nix-collect-garbage -d";
        ns = "SOPS_AGE_KEY_FILE=/etc/nixos/keys/$USER.txt sops";
        nu = "nix flake update /etc/nixos";
      };
    };
    dconf.enable = true;
  };
}
