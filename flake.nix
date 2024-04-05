{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprsome.url = "github:sopa0/hyprsome";

    #firefox-addons = {
    #  url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      inherit (self) outputs;
      lib = nixpkgs.lib // home-manager.lib;
    in {
      inherit lib;

      nixosConfigurations = {
        desktop = nixpkgs.lib.nixosSystem {
          modules = [ ./hosts/desktop ];
          specialArgs = { inherit inputs outputs; };
        };
      };

      #homeConfigurations = {
      #  "bhasher@desktop" = lib.homeManagerConfiguration {
      #    modules = [ ./home/bhasher.nix ];
      #    extraSpecialArgs = { inherit inputs outputs; };
      #  };
      #};
    };
}
