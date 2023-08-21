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
        color_scheme = "test",
      }
      '';
      colorSchemes.test = rec {
        ansi = [
          "#000000"
          "#ff3333"
          "#86b200"
          "#f19618"
          "#41a6d9"
          "#f07078"
          "#4cbe99"
          "#ffffff"
        ];
        brights = [
          "#323232"
          "#ff6565"
          "#b8e532"
          "#ffc849"
          "#73d7ff"
          "#ffa3aa"
          "#4cbe99"
          "#ffffff"
        ];
        foreground = "#5b6673";
        background = "#fafafa";
        cursor_bg = "#ff6900";
        cursor_border = "#ff6900";
        selection_bg = "#f0ede4";
        selection_fg = "#fafafa";
        scrollbar_thumb = "#333333";
        split = "#444444";
      };
      enableZshIntegration = true;
    };
  };
  
  home.stateVersion = "23.05";
}
