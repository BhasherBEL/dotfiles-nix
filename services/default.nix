{ ... }:
{
  imports = [
    ./nginx.nix
    ./dyndns.nix
    ./dns.nix
    ./vpn.nix
    ./vpn-client.nix
    ./fireflyiii.nix
    ./storage
    ./monitoring
    ./mediaserver
    ./auth
  ];
}
