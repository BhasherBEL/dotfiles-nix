{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    hyprsome = {
      url = "github:sopa0/hyprsome";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox = {
      url = "github:nix-community/flake-firefox-nightly";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-programs-sqlite = {
      url = "github:wamserma/flake-programs-sqlite";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.3";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko/v1.11.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    catppuccin = {
      url = "github:catppuccin/nix/v25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    import-tree.url = "github:vic/import-tree";
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    blog = {
      url = "github:bhasherbel/blog";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    simple-nixos-mailserver = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    maas-rs = {
      url = "github:bhasherbel/maas-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      ...
    }@inputs:
    let
      patches = [
        {
          name = "syncthing-init";
          id = "448845";
          sha256 = "sha256-/muOOY5cyOJM/ST6DBUjww4Ez7rUBqkYA5rl402qRG4=";
        }
      ];

      mkLibx =
        system:
        import ./lib {
          inherit
            self
            inputs
            system
            patches
            ;
        };

      libx = {
        x86_64-linux = mkLibx "x86_64-linux";
        aarch64-linux = mkLibx "aarch64-linux";
      };

    in
    {
      nixosConfigurations = {
        desktop = libx.x86_64-linux.makeNixosSystem "desktop" [
          ./hosts/desktop
          ./users/bhasher/desktop.nix
          inputs.lanzaboote.nixosModules.lanzaboote
        ];

        laptop = libx.x86_64-linux.makeNixosSystem "laptop" [
          ./hosts/laptop
          ./users/bhasher/laptop.nix
          inputs.lanzaboote.nixosModules.lanzaboote
        ];

        media-center = libx.aarch64-linux.makeNixosSystem "media-center" [
          ./hosts/media-center
          ./users/kodi/media-center.nix
          inputs.nixos-hardware.nixosModules.raspberry-pi-4
        ];

        live = libx.x86_64-linux.makeNixosSystem "live" [
          ./hosts/live
        ];

        spi = libx.aarch64-linux.makeNixosSystem "spi" [
          ./hosts/spi
          ./users/spi
          inputs.nixos-hardware.nixosModules.raspberry-pi-4
        ];
        shp = libx.x86_64-linux.makeNixosSystem "shp" [
          ./hosts/shp
          ./users/shp
        ];
        snc = libx.x86_64-linux.makeNixosSystem " snc" [
          ./hosts/snc
          inputs.disko.nixosModules.disko
        ];
      };

      homeConfigurations = {
        shp = libx.x86_64-linux.makeHomeManager "shp" [
          ./home/shp.nix
        ];
      };

      nixosModules = {
        # default =
        #   { ... }:
        #   {
        #     imports = [
        #       (inputs.import-tree ./services)
        #       (inputs.import-tree ./hosts/modules)
        #     ];
        #     _module.args.inputs = inputs;
        #   };
        services = inputs.import-tree ./services;
        # { ... }:
        # {
        #   imports = [ (inputs.import-tree ./services) ];
        #   _module.args.inputs = inputs;
        # };
        # hosts =
        #   { ... }:
        #   {
        #     imports = [ (inputs.import-tree ./hosts/modules) ];
        #     _module.args.inputs = inputs;
        #   };
      };

      homeModules = {
        # default =
        #   { ... }:
        #   {
        #     imports = [ (inputs.import-tree ./home/modules) ];
        #   };
      };

      deploy.nodes = {
        media-center = {
          hostname = "kodi";
          profiles.system = {
            user = "kodi";
            sshUser = "kodi";
            interactiveSudo = true;
            autoRollback = true;
            remoteBuild = false;
            path = inputs.deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.media-center;
          };
        };
        shp = {
          hostname = "shp";
          profiles.system = rec {
            user = "shp";
            sshUser = user;
            interactiveSudo = true;
            autoRollback = false;
            remoteBuild = true;
            path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations."${user}";
            profilePath = "/home/${user}/.local/state/nix/profiles/system";
          };
        };
        snc = {
          hostname = "snc";
          profiles.system = {
            user = "root";
            sshUser = "snc";
            interactiveSudo = true;
            autoRollback = false;
            remoteBuild = false;
            path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.snc;
          };
        };
      };
    };
}
