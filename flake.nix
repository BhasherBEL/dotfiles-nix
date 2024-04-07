{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprsome.url = "github:sopa0/hyprsome";

    nur.url = "github:nix-community/NUR";

    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs = { self, nixpkgs, home-manager, nur, nixos-hardware, ... }@inputs:
    let
      inherit (self) outputs;
      lib = nixpkgs.lib // home-manager.lib;
    in {
      inherit lib;

      nixosConfigurations = {
        desktop = nixpkgs.lib.nixosSystem {
          modules = [ { nixpkgs.overlays = [ nur.overlay ]; } ./hosts/desktop ];
          specialArgs = { inherit inputs outputs; };
        };
        media-center = nixpkgs.lib.nixosSystem {
          modules = [
            { nixpkgs.overlays = [ nur.overlay ]; }
            ./hosts/media-center
            nixos-hardware.nixosModules.raspberry-pi-4
          ];
          specialArgs = { inherit inputs outputs; };
        };
      };
    };
}
