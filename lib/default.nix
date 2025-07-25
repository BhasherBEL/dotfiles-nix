{
  self,
  inputs,
  system,
  patches,
  ...
}:
let
  homeConfiguration = "${self}/home";
  usersConfiguration = "${self}/users";
  hostsConfiguration = "${self}/hosts";
  homeModules = "${homeConfiguration}/modules";
  usersModules = "${usersConfiguration}/modules";
  hostsModules = "${hostsConfiguration}/modules";
  hostServices = "${self}/services";

  pre-nixpkgs = (import inputs.nixpkgs { inherit system; });

  nixpkgs-patched = pre-nixpkgs.applyPatches {
    name = "nixpkgs-patched";
    src = inputs.nixpkgs;
    patches = builtins.map (
      patch:
      (pre-nixpkgs.fetchpatch {
        name = patch.name or "pr-${patch.id}";
        url = "https://patch-diff.githubusercontent.com/raw/NixOS/nixpkgs/pull/${patch.id}.patch";
        sha256 = patch.sha256 or "";
      })
    ) patches;
  };

  nixpkgs = nixpkgs-patched;

  lib = nixpkgs.lib // inputs.home-manager.lib;

  nixosSystem = (import (nixpkgs + "/nixos/lib/eval-config.nix"));
in
{
  inherit lib;

  makeNixosSystem =
    hostname: extraModules:
    nixosSystem {
      inherit system;
      specialArgs = {
        inherit
          inputs
          homeModules
          usersModules
          hostsModules
          hostServices
          hostname
          ;
      };
      modules = [
        { nixpkgs.overlays = [ inputs.nur.overlays.default ]; }
        inputs.flake-programs-sqlite.nixosModules.programs-sqlite
        inputs.catppuccin.nixosModules.catppuccin
        inputs.stylix.nixosModules.stylix
        inputs.sops-nix.nixosModules.sops
        inputs.home-manager.nixosModules.default
        {
          home-manager.extraSpecialArgs = {
            inherit
              inputs
              homeModules
              hostname
              system
              ;
          };
        }
        ../overlays
        "${hostsModules}"
        "${usersModules}"
        "${hostServices}"
        #"${homeConfiguration}"
      ]
      ++ extraModules;
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
          system
          ;
      };
      modules = [
        { nixpkgs.overlays = [ inputs.nur.overlays.default ]; }
        inputs.catppuccin.homeModules.catppuccin
        inputs.stylix.homeManagerModules.stylix
        inputs.sops-nix.homeManagerModules.sops
        {
          targets.genericLinux.enable = true;
        }
      ]
      ++ extraModules;
    };

}
