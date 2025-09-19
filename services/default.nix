{ ... }:
{
  imports = [
    ./nginx.nix
    ./dyndns.nix
    ./dns.nix
    ./vpn.nix
    ./monitoring
    ./mediaserver
  ];
}
