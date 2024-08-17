{
  self,
  nixpkgs,
  inputs,
  ...
}:
let
  homeConfiguration = "${self}/home";
  hostConfiguration = "${self}/hosts";
  homeModules = "${homeConfiguration}/modules";
  hostModules = "${hostConfiguration}/modules";
in
{
  makeNixosSystem =
    hostname: extraModules:
    nixpkgs.lib.nixosSystem rec {
      specialArgs = {
        inherit
          inputs
          homeModules
          hostModules
          hostname
          ;
      };
      modules = [
        { nixpkgs.overlays = [ inputs.nur.overlay ]; }
        inputs.flake-programs-sqlite.nixosModules.programs-sqlite
        inputs.catppuccin.nixosModules.catppuccin
        inputs.home-manager.nixosModules.default
        { home-manager.extraSpecialArgs = specialArgs; }
        #"${hostConfiguration}"
        #"${homeConfiguration}"
      ] ++ extraModules;
    };
}
