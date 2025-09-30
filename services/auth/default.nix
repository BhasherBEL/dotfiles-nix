{ ... }:
{
  imports = [
    ./openldap.nix
    ./lldap.nix
    ./authelia
  ];
}
