{ ... }:
{
  imports = [
    ./nginx.nix
    ./dyndns.nix
    ./monitoring
    ./mediaserver
  ];
}
