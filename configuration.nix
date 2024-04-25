{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;

  launchd.user.agents."toggleAirport" = {
    serviceConfig = {
      Label = "com.mine.toggleairport";
      RunAtLoad = true;
    };
    command = ./toggleAirport.sh;
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
    ];
  }; 

  security.pam.enableSudoTouchIdAuth = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";    
    settings = {
      trusted-users = [
        "root"
        "yamashita"
      ];
    };
  };
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Darwin settings
  system = {
    activationScripts.extraActivation.text = ''
      softwareupdate --install-rosetta --agree-to-license
    '';

    defaults = {
      dock = {
        autohide = true;
        appswitcher-all-displays = true;
        persistent-apps = [
          "/Applications/Safari.app"
          "/Users/yamashita/Applications/Home Manager Apps/WezTerm.app"
          "/Users/yamashita/Applications/Home Manager Apps/TablePlus.app"
        ];
      };

      finder = {
        AppleShowAllFiles = true;
        ShowStatusBar = true;
        ShowPathbar = true;
        FXDefaultSearchScope = "SCcf";
        FXPreferredViewStyle = "Nlsv";
      };

      NSGlobalDomain = {
        "com.apple.sound.beep.volume" = 0.6065307;
        _HIHideMenuBar = false;
        AppleMeasurementUnits = "Centimeters";
        AppleMetricUnits = 1;
        ApplePressAndHoldEnabled = false;
        AppleTemperatureUnit = "Celsius";
        InitialKeyRepeat = 15;
        KeyRepeat = 1;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSTableViewDefaultSizeMode = 2;
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

  system.stateVersion = 4;
}
