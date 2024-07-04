{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # By-screen workspaces
    hyprsome.url = "github:sopa0/hyprsome";

    nur.url = "github:nix-community/NUR";

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Secret management
    sops-nix.url = "github:Mic92/sops-nix";

    firefox.url = "github:nix-community/flake-firefox-nightly";
  };

  outputs =
    { nixpkgs, home-manager, ... }@inputs:
    let
      lib = nixpkgs.lib // home-manager.lib;
    in
    {
      inherit lib;

      nixosConfigurations = {
        desktop = nixpkgs.lib.nixosSystem rec {
          specialArgs = {
            inherit inputs;
          };
          modules = [
            { nixpkgs.overlays = [ inputs.nur.overlay ]; }
            ./hosts/desktop
            ./users/bhasher/desktop.nix
            home-manager.nixosModules.default
            { home-manager.extraSpecialArgs = specialArgs; }
          ];
        };
        laptop = nixpkgs.lib.nixosSystem rec {
          specialArgs = {
            inherit inputs;
          };
          modules = [
            { nixpkgs.overlays = [ inputs.nur.overlay ]; }
            ./hosts/laptop
            ./users/bhasher/laptop.nix
            home-manager.nixosModules.default
            { home-manager.extraSpecialArgs = specialArgs; }
          ];
        };
        media-center = nixpkgs.lib.nixosSystem {
          modules = [
            { nixpkgs.overlays = [ inputs.nur.overlay ]; }
            ./hosts/media-center
            ./users/kodi
            inputs.nixos-hardware.nixosModules.raspberry-pi-4
          ];
          specialArgs = {
            inherit inputs;
          };
        };
      };
    };
}
