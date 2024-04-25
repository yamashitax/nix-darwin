{
  description = "A flake with extendable profiles";

  nixConfig.extra-experimental-features = "nix-command flakes";

  inputs = {
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
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
    wezterm.url = "github:notohh/wezterm?dir=nix&ref=nix-add-overlay";
    zig.url = "github:mitchellh/zig-overlay";
  };

  outputs = inputs @ { self, nix-darwin, nixpkgs, home-manager, devenv, zig, helix-master, catppuccin-helix, nix-homebrew, ... }: {
    darwinConfigurations = let
      makeConfig = name: modules: nix-darwin.lib.darwinSystem {
        modules = [
          ./configuration.nix
          ./home/${name}/configuration.nix
        ] ++ modules ++ [
          home-manager.darwinModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit devenv zig helix-master catppuccin-helix nixpkgs; };
            home-manager.users = {
              ${name} = import ./home/${name}/home.nix;
            };
          }
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              enableRosetta = true;
              user = "yamashita";
            };
          }
        ];
      };
    in {
      default = makeConfig "yamashita" [];
    };

    darwinPackages = self.darwinConfigurations.default.pkgs;
  };
}
