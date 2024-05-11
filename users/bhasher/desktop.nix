{ ... }:
{
  imports = [
    ./default.nix
    ../optional/docker.nix
    ../optional/virtualbox.nix
    #../optional/java.nix
    ../optional/go.nix
    # Not working, probably related to https://github.com/rustdesk/rustdesk/issues/3565
    #../optional/rustdesk.nix
    ../optional/vscodium.nix
  ];
}
