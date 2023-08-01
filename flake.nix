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
  };

  outputs = inputs @ { self, darwin, nixpkgs, home-manager, ... }:
    let
      system = "aarch64-darwin";
    in {
      darwinConfigurations = {
        yamashita = darwin.lib.darwinSystem {
	  inherit system;
	  modules = [
	    ./configuration.nix

	    home-manager.darwinModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users = {
                work.imports = [ ./home/work.nix ];
                yamashita.imports = [ ./home/yamashita.nix ];
              };
            }
	  ];
	};
      };
    };
}
