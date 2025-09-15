{ ... }:
{
  imports = [
    ./nginx.nix
    ./dyndns.nix
    ./dns.nix
    ./monitoring
    ./mediaserver
  ];
}
