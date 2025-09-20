{ ... }:
{
  imports = [
    ./nginx.nix
    ./dyndns.nix
    ./dns.nix
    ./vpn.nix
    ./storage
    ./monitoring
    ./mediaserver
    ./auth
  ];
}
