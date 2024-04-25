{
  devenv,
  lib, 
  nil,
  pkgs,
  zig,
  helix-master,
  nixpkgs,
  catppuccin-helix,
  runCommand,
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
in {
  home.packages = with pkgs; [
    asciinema
    bat
    devenv.packages."${pkgs.system}".devenv
    fd
    helix-gpt
    hyperfine
    meld
    mos
    nodePackages."@tailwindcss/language-server"
    nodePackages.intelephense
    nodePackages.typescript
    nodePackages.typescript-language-server
    nodePackages.volar
    nodePackages.vscode-langservers-extracted
    nodejs-slim
    rectangle
    sensible-side-buttons
    tableplus
    telegram-desktop
    zig.packages."${pkgs.system}".master
    zls
    zoom-us
  ];

  programs = {
    direnv.enable = true;

    fzf.enable = true;

    git ={
      enable = true;
      ignores = [
        ".DS_Store"
      ];
    };

    jujutsu = {
      enable = true;
      settings = {
        ui = {
          editor = "hx";
          default-command = "log";
        };
        user = {
          name = "山下";
          email = "git@yamashit.ax";
        };
        snapshot.max-new-file-size = "10MiB";
        template-aliases = {
          "format_short_signature(signature)" = "signature.username()";
          "format_short_id(id)" = "id.shortest()";
        };
      };
    };

    helix = {
      enable = true;
      package = pkgs.helix;
      settings = {
        theme = "catppuccin_latte";

        editor = {
          color-modes = true;
          bufferline = "multiple";
          completion-trigger-len = 3;
          line-number = "relative";
          indent-guides.render = true;
          indent-guides.character = "┊";

          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };
        };

        keys = {
          normal = {
            space = {
              e = ":write";
              q = ":quit";
              space = "goto_last_accessed_file";
            };
          };
        };
      };

      languages = {
        language-server = with pkgs; {
          codeium = {
            command = "${helix-gpt}/bin/helix-gpt";
            args = [ "--handler" "codeium" ];
          };
        };
        language = [
          {
            name = "nix";
            auto-format = true;
            formatter = { command = "nixpkgs-fmt"; };
            language-servers = ["nil" "codeium"];
          }
          {
            name = "php";
            language-servers = ["intelephense" "codeium"];
          }
          {
            name = "zig";
            language-servers = ["zls" "codeium"];
          }
        ];
      };
    };

    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
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
        keys = {
          { key = "UpArrow",   mods = "SHIFT", action = wezterm.action.ScrollToPrompt(-1) },
          { key = "DownArrow", mods = "SHIFT", action = wezterm.action.ScrollToPrompt(1) },
        },
        font = wezterm.font("JetBrains Mono"),
        hide_tab_bar_if_only_one_tab = true,
        color_scheme = "Catppuccin Latte",
      }
      '';
      enableZshIntegration = true;
    };

    zsh.enable = true;
  };

  home.file.".config/helix/themes".source = "${catppuccin-helix}/themes/default";
  home.stateVersion = "23.11";
}
