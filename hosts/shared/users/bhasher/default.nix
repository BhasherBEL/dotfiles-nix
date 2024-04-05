{ pkgs, config, ... }:
let
  ifTheyExist = groups:
    builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  imports = [
    ../../optional/python.nix
    ../../optional/languagelab.nix
    ../../optional/docker.nix
  ];

  home-manager.users.bhasher = import ../../../../home/bhasher.nix;

  users.users.bhasher = {
    isNormalUser = true;
    initialPassword = "azerty";
    extraGroups = [ "wheel" "audio" ] ++ ifTheyExist [ "docker" "wireshark" ];
  };

  environment.systemPackages = with pkgs; [
    tree
    zsh-powerlevel10k
    freetube
    signal-desktop
    font-awesome
    xorg.xlsclients
    stylua
    nixfmt
    prettierd
    ferdium
    nil
    thunderbird
    dnsutils
    asciinema
    onlyoffice-bin
    mdcat
  ];
}
