{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    devenv.url = "github:cachix/devenv/latest";
    zig.url = "github:mitchellh/zig-overlay";

    catppuccin-wezterm = {
      url = "github:catppuccin/wezterm";
      flake = false;
    };

    catppuccin-helix = {
      url = "github:catppuccin/helix";
      flake = false;
    };
    
    helix-master.url = "github:helix-editor/helix";
    
    nil.url = "github:oxalica/nil";
  };

  outputs = inputs @ { self, darwin, nixpkgs, home-manager, devenv, zig, nil, helix-master, catppuccin-helix, ... }:
    let
      system = "aarch64-darwin";
    in {
      darwinConfigurations = {
        yamashita = darwin.lib.darwinSystem {
      	  inherit system;
      	  modules = [
      	    ./configuration.nix
      	    ./home/yamashita/configuration.nix
      	    ./home/work/configuration.nix

      	    home-manager.darwinModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit devenv zig nil helix-master catppuccin-helix; };
              home-manager.backupFileExtension = "backup.bak";
              home-manager.users = {
                work      = import ./home/work/home.nix;
                yamashita = import ./home/yamashita/home.nix;
              };
            }
      	  ];
      	};
      };
    };
}
