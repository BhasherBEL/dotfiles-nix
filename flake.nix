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
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      lib = nixpkgs.lib // home-manager.lib;
    in
    {
      inherit lib;

      nixosConfigurations = {
        desktop = nixpkgs.lib.nixosSystem {
          modules = [
            { nixpkgs.overlays = [ inputs.nur.overlay ]; }
            ./hosts/desktop
            ./users/bhasher/desktop.nix
          ];
          specialArgs = {
            inherit inputs outputs;
          };
        };
        laptop = nixpkgs.lib.nixosSystem {
          modules = [
            { nixpkgs.overlays = [ inputs.nur.overlay ]; }
            ./hosts/laptop
            ./users/bhasher/laptop.nix
          ];
          specialArgs = {
            inherit inputs outputs;
          };
        };
        media-center = nixpkgs.lib.nixosSystem {
          modules = [
            { nixpkgs.overlays = [ inputs.nur.overlay ]; }
            ./hosts/media-center
            ./users/kodi
            inputs.nixos-hardware.nixosModules.raspberry-pi-4
          ];
          specialArgs = {
            inherit inputs outputs;
          };
        };
      };
    };
}
