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

  stylix-patched = import (
    pre-nixpkgs.applyPatches {
      name = "stylix-patched";
      src = inputs.stylix;
      patches = [
        (pre-nixpkgs.fetchpatch {
          name = "Stylix overlay fixes";
          url = "https://patch-diff.githubusercontent.com/raw/danth/stylix/pull/866.diff";
          sha256 = "sha256-CYb6jn0ZQxOcjMrIB++6FFTLy67qPHmmd+ebvzyMc+k=";
        })
      ];
    }
  );
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
          hostname
          ;
      };
      modules = [
        { nixpkgs.overlays = [ inputs.nur.overlays.default ]; }
        inputs.flake-programs-sqlite.nixosModules.programs-sqlite
        inputs.catppuccin.nixosModules.catppuccin
        stylix-patched.nixosModules.stylix
        inputs.home-manager.nixosModules.default
        {
          home-manager.extraSpecialArgs = {
            inherit inputs homeModules hostname;
          };
        }
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
        stylix-patched.homeManagerModules.stylix
        inputs.sops-nix.homeManagerModules.sops
        {
          targets.genericLinux.enable = true;
        }
      ] ++ extraModules;
    };

}
