{ homeModules, ... }:
{
  # TODO: Find a way to avoid to list them here

  imports = [
    "${homeModules}/firefox.nix"
    "${homeModules}/git.nix"
    "${homeModules}/ssh.nix"
    "${homeModules}/syncthing.nix"
    "${homeModules}/joplin-desktop.nix"
    "${homeModules}/kdeconnect.nix"
  ];
}
