{
  description = "A very basic flake";

  nixConfig = {
    extra-experimental-features = "nix-command flakes";
  };

  inputs = {
    catppuccin-helix.url = "github:catppuccin/helix";
    catppuccin-helix.flake = false;
    catppuccin-wezterm.url = "github:catppuccin/wezterm";
    catppuccin-wezterm.flake = false;

    copilot-vim.flake = false;
    copilot-vim.url = "github:github/copilot.vim";

    crane.inputs.nixpkgs.follows = "nixpkgs";
    crane.url = "github:ipetkov/crane";

    devenv.inputs.flake-compat.follows = "flake-compat";
    devenv.inputs.nixpkgs.follows = "nixpkgs";
    devenv.url = "github:cachix/devenv";

    flake-compat.flake = false;
    flake-compat.url = "github:edolstra/flake-compat";

    flake-utils.url = "github:numtide/flake-utils";

    helix-master.inputs.crane.follows = "crane";
    helix-master.inputs.flake-utils.follows = "flake-utils";
    helix-master.inputs.nixpkgs.follows = "nixpkgs";
    helix-master.url = "github:helix-editor/helix";

    home-manager.url = github:nix-community/home-manager;
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    wezterm.flake = false;
    wezterm.url = "git+https://github.com/wez/wezterm/?rev=600652583594e9f6195a6427d1fabb09068622a7&submodules=1";

    zig.url = "github:mitchellh/zig-overlay";
  };

  outputs = inputs @ { self, nix-darwin, nixpkgs, home-manager, devenv, zig, helix-master, catppuccin-helix, ... }: {
    # overlays = import ./overlays { inherit inputs; };
    
    darwinConfigurations."default" = nix-darwin.lib.darwinSystem {
      modules = [
        ./configuration.nix
  	    ./home/personal/configuration.nix
  	    ./home/work/configuration.nix

        home-manager.darwinModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit devenv zig helix-master catppuccin-helix nixpkgs; };
          home-manager.users = {
            work     = import ./home/work/home.nix;
            yamashita = import ./home/personal/home.nix;
          };
        }
      ];
    };

    darwinPackages = self.darwinConfigurations."default".pkgs;
  };
  
  # outputs = inputs @ { self, darwin, nixpkgs, home-manager, devenv, zig, nil, helix-master, catppuccin-helix, ... }:
  #   let
  #     system = "aarch64-darwin";
  #   in {
  #     darwinConfigurations = {
  #       yamashita = darwin.lib.darwinSystem {
  #     	  inherit system;
  #     	  modules = [
  #     	    ./configuration.nix
  #     	    ./home/yamashita/configuration.nix
  #     	    ./home/work/configuration.nix

  #     	    home-manager.darwinModules.home-manager {
  #             home-manager.useGlobalPkgs = true;
  #             home-manager.useUserPackages = true;
  #             home-manager.extraSpecialArgs = { inherit devenv zig nil helix-master catppuccin-helix; };
  #             home-manager.backupFileExtension = "backup.bak";
  #             home-manager.users = {
  #               work      = import ./home/work/home.nix;
  #               yamashita = import ./home/yamashita/home.nix;
  #             };
  #           }
  #     	  ];
  #     	};
  #     };
  #   };
}
