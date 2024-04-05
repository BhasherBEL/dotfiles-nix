{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follow = "nixpkgs";
    };
    hyprsome.url = "github:sopa0/hyprsome";
  };

  outputs = { nixpkgs, home-manager, hyprsome, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.moonlighter69 = {
            home.packages = [ hyprsome.packages.x86_64-linux.default ];
          };
        }
      ];
    };
  };
}
