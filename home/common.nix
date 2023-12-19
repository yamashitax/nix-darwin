{
  devenv,
  lib, 
  nil,
  pkgs,
  zig,
  helix-master,
  catppuccin-helix,
  ... 
}: 
let
  libresprite = pkgs.libresprite.overrideAttrs(finalAttrs: {
    src = pkgs.fetchFromGitHub {
      owner = "LibreSprite";
      repo = "LibreSprite";
      rev = "4dac17fd198288d91c07592373449dcdddaf7e24";
      fetchSubmodules = true;
      sha256 = "sha256-kh09ERqH8hFF8Dq6c7ea4fBGV6yQFfazoHTRAk+xwOQ=";
    };

    meta = with lib; {
      broken = false;
    };
  });

  # copilot = pkgs.writeShellApplication {
  #   name = "copilot";
  #   text = ''
  #     ${pkgs.nodejs-slim}/bin/node ${pkgs.vimPlugins.copilot-vim}/dist/agent.js "''$@" 
  #   '';
  # };

  # helix = helix-master.packages."${pkgs.system}".default.overrideAttrs (finalAttrs: {
  #   patches = (finalAttrs.patches or []) ++ [
  #     (pkgs.fetchpatch {
  #       url = "https://patch-diff.githubusercontent.com/raw/helix-editor/helix/pull/6865.patch";
  #       hash = "sha256-qI+seNGaW/p8iiV1HVVcm/acJ8IRWVslEkQPJAHNsxo=";
  #     })
  #   ];
  # });
in {
  home.packages = with pkgs; [
    bat
    devenv.packages."${pkgs.system}".devenv
    fd
    nodePackages."@tailwindcss/language-server"
    nodePackages.intelephense
    nodePackages.typescript
    nodePackages.typescript-language-server
    nodePackages.vls
    nodePackages.vscode-langservers-extracted
    nodePackages.vue-language-server
    nodejs-slim
    prettierd
    rectangle
    zig.packages."${pkgs.system}".master
    zls
    # vimPlugins.copilot-vim
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

    helix = {
      enable = true;
      package = helix-master.packages."${pkgs.system}".default;
      # languages = {
      #   language-server = {
      #     # typescript-language-server = with pkgs.nodePackages; {
      #     #   command = "${typescript-language-server}/bin/typescript-language-server";
      #     #   args = [ "--stdio" "--tsserver-path=''${typescript}/lib/node_modules/typescript/lib" ];
      #     # };
      #     copilot = with pkgs; with vimPlugins; {
      #       command = "${copilot}/bin/copilot";
      #       args = [ "--stdio" ];
      #     };
      #   };
      #   language = [
      #     {
      #       name = "typescript";
      #       language-servers = [ "typescript-language-server" "copilot" ];
      #     }
      #   ];
      # };
      settings = {
        theme = "catppuccin_latte";
        editor = {
          auto-completion = true;
          bufferline = "multiple";
          line-number = "relative";
          lsp = {
            auto-signature-help = false;
            display-messages = true;
            display-inlay-hints = true;
            # copilot-auto = true;
          };
          statusline = {
            left = ["mode" "spinner"];
            center = ["file-name" "file-encoding" "version-control"];
            right = ["diagnostics" "selections"];
          };
        };
        # keys = {
        #   normal = {
        #     "C-y" = "toggle_copilot_auto";
        #   };
        #   insert = {
        #     "C-e" = "show_or_next_copilot_completion";
        #     "C-a" = "hide_or_prev_copilot_completion";
        #     "C-y" = "apply_copilot_completion";
        #   };
        # };
      };
    };

    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      # plugins = with pkgs.vimPlugins; [ copilot-vim ];

      # extraLuaConfig = ''
      #   ${lib.strings.fileContents ./init.lua}
      # '';
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
        color_scheme = "Catppuccin Latte",
      }
      '';
      enableZshIntegration = true;
    };
    zsh = {
      enable = true;
    };
  };

  home.file.".config/helix/themes".source = "${catppuccin-helix}/themes/default";
  home.file.".config/helix/languages.toml".text = builtins.readFile ./helix/languages-default.toml;
  home.stateVersion = "23.05";
}
