{
  self,
  nixpkgs,
  inputs,
  system,
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
        { nixpkgs.overlays = [ inputs.nur.overlays.default ]; }
        inputs.flake-programs-sqlite.nixosModules.programs-sqlite
        inputs.catppuccin.nixosModules.catppuccin
        inputs.stylix.nixosModules.stylix
        inputs.home-manager.nixosModules.default
        { home-manager.extraSpecialArgs = specialArgs; }
        ../overlays
        "${hostsModules}"
        "${usersModules}"
        #"${homeConfiguration}"
      ] ++ extraModules;
    };

  makeHomeManager =
    username: extraModules:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      extraSpecialArgs = {
        inherit
          inputs
          homeModules
          username
          ;
      };
      modules = [
        { nixpkgs.overlays = [ inputs.nur.overlays.default ]; }
        inputs.catppuccin.homeManagerModules.catppuccin
        inputs.stylix.homeManagerModules.stylix
				inputs.sops-nix.homeManagerModules.sops
				{ targets.genericLinux.enable = true; }
      ] ++ extraModules;
    };
}
