{ ... }:
{
  imports = [
    ./nginx.nix
    ./dyndns.nix
    ./dns.nix
    ./vpn.nix
    ./vpn-client.nix
    ./storage
    ./monitoring
    ./mediaserver
    ./auth
  ];
}
