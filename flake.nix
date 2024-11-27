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
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-programs-sqlite = {
      url = "github:wamserma/flake-programs-sqlite";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    catppuccin.url = "github:catppuccin/nix";
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      lib = nixpkgs.lib // home-manager.lib;
      libx = import ./lib { inherit self inputs nixpkgs; };

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
            inputs.flake-programs-sqlite.nixosModules.programs-sqlite
            inputs.catppuccin.nixosModules.catppuccin
          ] ++ extraModules;
        };
    in
    {
      inherit lib;

      nixosConfigurations = {
        desktop = makeNixosSystem "desktop" [
          ./hosts/desktop
          ./users/bhasher/desktop.nix
          inputs.lanzaboote.nixosModules.lanzaboote
        ];

        laptop = libx.makeNixosSystem "laptop" [
          ./hosts/laptop
          ./users/bhasher/laptop.nix
          inputs.lanzaboote.nixosModules.lanzaboote
        ];

        laptop-home = makeNixosSystem "laptop-home" [
          ./hosts/laptop-home
          ./users/bhasher/laptop.nix
          inputs.lanzaboote.nixosModules.lanzaboote
          inputs.disko.nixosModules.disko
        ];

        media-center = libx.makeNixosSystem "media-center" [
          ./hosts/media-center
          ./users/kodi/media-center.nix
          inputs.nixos-hardware.nixosModules.raspberry-pi-4
          inputs.impermanence.nixosModules.impermanence
        ];
      };
    };
}
