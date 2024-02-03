{ config, pkgs, ... }:

{
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
      EDITOR = "hx";
      VISUAL = "hx";
    };
  };

  homebrew = {                            # Declare Homebrew using Nix-Darwin
    enable = true;
    onActivation = {
      autoUpdate = true;                 # Auto update packages
      upgrade = false;
      cleanup = "zap";                    # Uninstall not listed packages and casks
    };
    casks = [
      "google-japanese-ime"
      "librewolf"
      "sensiblesidebuttons"
    ];
  }; 

  security.pam.enableSudoTouchIdAuth = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";    
  };
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Darwin settings
  system = {
    activationScripts.extraActivation.text = ''
      softwareupdate --install-rosetta --agree-to-license
    '';

    defaults = {
      NSGlobalDomain = {
        AppleMeasurementUnits = "Centimeters";
        AppleMetricUnits = 1;
        ApplePressAndHoldEnabled = false;
        AppleTemperatureUnit = "Celsius";
        InitialKeyRepeat = 15;
        KeyRepeat = 1;
      };

      trackpad = {
        ActuationStrength = 0; # silent clicking
        FirstClickThreshold = 0; # light clicking
        SecondClickThreshold = 0; # light force touch
      };
    };

    keyboard.enableKeyMapping = true;
  };
  


  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina

  # system.activationScripts.extraActivation.text = ''
  #   # ls -al ${pkgs.toggle-airport}/etc
  #   # launchctl load -w /Library/LaunchAgents/com.mine.toggleairport.plist
  # '';

  system.stateVersion = 4;
}
