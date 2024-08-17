{ homeModules, ... }:
{
  # TODO: Find a way to avoid to list them here

  imports = [ "${homeModules}/firefox.nix" ];
}
