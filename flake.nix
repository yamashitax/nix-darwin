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

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    devenv.url = "github:cachix/devenv/latest";
    zig.url = "github:mitchellh/zig-overlay";
  };

  outputs = inputs @ { self, darwin, nixpkgs, home-manager, nix-vscode-extensions, devenv, zig, ... }:
    let
      system = "aarch64-darwin";
      extensions = nix-vscode-extensions;
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
              home-manager.extraSpecialArgs = { inherit extensions devenv zig; };
              home-manager.backupFileExtension = "backup";
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