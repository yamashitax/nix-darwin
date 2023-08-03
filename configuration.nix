{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search by name, run:
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;

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
      EDITOR = "codium";
      VISUAL = "codium";
    };
  };

  homebrew = {                            # Declare Homebrew using Nix-Darwin
    enable = true;
    onActivation = {
      autoUpdate = true;                 # Auto update packages
      upgrade = false;
      cleanup = "zap";                    # Uninstall not listed packages and casks
    };
    casks = [ "google-japanese-ime" ];
  }; 

  security.pam.enableSudoTouchIdAuth = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";    
  };

  # Darwin settings
  system.defaults.NSGlobalDomain.AppleMeasurementUnits = "Centimeters";
  system.defaults.NSGlobalDomain.AppleMetricUnits = 1;
  system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;
  system.defaults.NSGlobalDomain.AppleTemperatureUnit = "Celsius";
  system.defaults.NSGlobalDomain.InitialKeyRepeat = 15;
  system.defaults.NSGlobalDomain.KeyRepeat = 1;
  
  system.defaults.trackpad.ActuationStrength = 0; # silent clicking
  system.defaults.trackpad.FirstClickThreshold = 0; # light clicking
  system.defaults.trackpad.SecondClickThreshold = 0; # light force touch

  system.keyboard.enableKeyMapping = true;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina

  system.stateVersion = 4;
}