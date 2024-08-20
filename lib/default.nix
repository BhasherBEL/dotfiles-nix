{
  self,
  nixpkgs,
  inputs,
  ...
}:
let
  homeConfiguration = "${self}/home";
  usersConfiguration = "${self}/users";
  hostsConfiguration = "${self}/hosts";
  homeModules = "${homeConfiguration}/modules";
  usersModules = "${usersConfiguration}/modules";
  hostsModules = "${hostsConfiguration}/modules";
in
{
  makeNixosSystem =
    hostname: extraModules:
    nixpkgs.lib.nixosSystem rec {
      specialArgs = {
        inherit
          inputs
          homeModules
          usersModules
          hostsModules
          hostname
          ;
      };
      modules = [
        { nixpkgs.overlays = [ inputs.nur.overlay ]; }
        inputs.flake-programs-sqlite.nixosModules.programs-sqlite
        inputs.catppuccin.nixosModules.catppuccin
        inputs.stylix.nixosModules.stylix
        inputs.home-manager.nixosModules.default
        { home-manager.extraSpecialArgs = specialArgs; }
        ../overlays
        #"${hostConfiguration}"
        #"${homeConfiguration}"
        "${usersModules}"
      ] ++ extraModules;
    };
}
