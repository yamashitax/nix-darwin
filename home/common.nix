{
  devenv,
  lib, 
  nil,
  pkgs,
  zig,
  ... 
}: let
in {
  home.packages = with pkgs; [
    cargo
    devenv.packages."${pkgs.system}".devenv
    fd
    nodejs-slim
    rectangle
    zig.packages."${pkgs.system}".master-2023-07-05
  ];

  programs = {
    direnv = {
      enable = true;
    };

    fzf = {
      enable = true;
    };

    git = {
      enable = true;
      userName = "山下";
    };

    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;

      extraLuaConfig = ''
        ${lib.strings.fileContents ./init.lua}
      '';
    };
  
    ripgrep = {
      enable = true;
    };
  
    ssh = {
      extraConfig = ''
        Host *
          UseKeychain yes
          AddKeysToAgent yes
          IdentityFile ~/.ssh/id_ed25519
      '';
    };

    wezterm = {
      enable = true;
      extraConfig = ''
      return {
        font = wezterm.font("JetBrains Mono"),
        hide_tab_bar_if_only_one_tab = true,
      }
      '';
      enableZshIntegration = true;
    };
  };
  
  home.stateVersion = "23.05";
}
