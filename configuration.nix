{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;

  users.users."yamashita" = {               # macOS user
    home = "/Users/yamashita";
    shell = pkgs.zsh;                     # Default shell
  };

  fonts = {                               # Fonts
    fontDir.enable = true;
    fonts = with pkgs; [
      (nerdfonts.override {
        fonts = [
          "JetBrainsMono"
        ];
      })
    ];
  };

  environment = {
    shells = with pkgs; [ zsh ];          # Default shell
    variables = {                         # System variables
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
    systemPackages = with pkgs; [         # Installed Nix packages
      # Terminal
      direnv
      fd
      git
      rectangle
      ripgrep
      silver-searcher
      # zig.packages."${system}".master
    ];
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # nix.package = pkgs.nix;
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";    
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina

  system.stateVersion = 4;
}
