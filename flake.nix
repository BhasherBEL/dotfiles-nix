{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hyprsome.url = "github:sopa0/hyprsome";
    nur.url = "github:nix-community/NUR";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    sops-nix.url = "github:Mic92/sops-nix";
    firefox.url = "github:nix-community/flake-firefox-nightly";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }@inputs:
    let
      lib = nixpkgs.lib // home-manager.lib;

      makeNixosSystem =
        name: extraModules:
        nixpkgs.lib.nixosSystem rec {
          specialArgs = {
            inherit inputs;
          };
          modules = [
            { nixpkgs.overlays = [ inputs.nur.overlay ]; }
            home-manager.nixosModules.default
            { home-manager.extraSpecialArgs = specialArgs; }
          ] ++ extraModules;
        };
    in
    {
      inherit lib;

      nixosConfigurations = {
        desktop = makeNixosSystem "desktop" [
          ./hosts/desktop
          ./users/bhasher/desktop.nix
        ];

        laptop = makeNixosSystem "laptop" [
          ./hosts/laptop
          ./users/bhasher/laptop.nix
        ];

        media-center = makeNixosSystem "media-center" [
          ./hosts/media-center
          ./users/kodi
          inputs.nixos-hardware.nixosModules.raspberry-pi-4
        ];
      };
    };
}
