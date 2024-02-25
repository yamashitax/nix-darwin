{
  devenv,
  lib, 
  nil,
  pkgs,
  zig,
  helix-master,
  nixpkgs,
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
in {
  nixpkgs.overlays = [
    (final: prev: {
      helix = final.helix.overrideAtttrs(oldAttrs: {
        patches = [
          (pkgs.fetchpatch {
            url = "https://patch-diff.githubusercontent.com/raw/helix-editor/helix/pull/6865.patch";
            hash = "sha256-qI+seNGaW/p8iiV1HVVcm/acJ8IRWVslEkQPJAHNsxo=";
          })
        ];
      });
    })
  ];
  
  home.packages = with pkgs; [
    asciinema
    bat
    devenv.packages."${pkgs.system}".devenv
    fd
    hyperfine
    nodePackages."@tailwindcss/language-server"
    nodePackages.intelephense
    nodePackages.typescript
    nodePackages.typescript-language-server
    nodePackages.volar
    nodePackages.vscode-langservers-extracted
    nodejs-slim
    rectangle
    telegram-desktop
    zig.packages."${pkgs.system}".master
    zls
  ];

  programs = {
    direnv = {
      enable = true;
    };

    fzf = {
      enable = true;
    };

    git.ignores = [
      ".DS_Store"
    ];

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
        language-server = {
          nu-lsp = {
            command = "${pkgs.nushell}/bin/nu";
            args = ["--lsp"];
          };
          rust-analyzer = {
            config.check.command = "clippy";
          };
          yaml-language-server = {
            config.yaml.format.enable = true;
            config.yaml.validation = true;
            config.yaml.schemas = {
              "https://json.schemastore.org/github-workflow.json" = ".github/{actions,workflows}/*.{yml,yaml}";
              "https://raw.githubusercontent.com/ansible-community/schemas/main/f/ansible-tasks.json" = "roles/{tasks,handlers}/*.{yml,yaml}";
              kubernetes = "kubernetes/*.{yml,yaml}";
            };
          };
          godot = {
            command = "nc";
            args = [ "127.0.0.1" "6005" ];
          };
        };
        language = [
          {
            name = "nix";
            formatter = {command = "alejandra";};
            language-servers = ["nil"];
            auto-format = true;
          }
          {
            name = "rust";
            language-servers = ["rust-analyzer"];
          }
          {
            name = "lua";
            language-servers = ["lua-language-server"];
          }
          {
            name = "javascript";
            language-servers = ["typescript-language-server"];
          }
          {
            name = "typescript";
            language-servers = ["typescript-language-server"];
          }
          {
            name = "bash";
            language-servers = ["bash-language-server"];
          }
          {
            name = "hcl";
            language-servers = ["terraform-ls"];
          }
          {
            name = "tfvars";
            language-servers = ["terraform-ls"];
          }
          {
            name = "go";
            language-servers = ["gopls"];
          }
          {
            name = "nu";
            language-servers = ["nu-lsp"];
          }
          {
            name = "css";
            language-servers = ["vscode-css-language-server"];
          }
          {
            name = "html";
            language-servers = ["vscode-html-language-server"];
            auto-format = true;
          }
          {
            name = "yaml";
            language-servers = ["yaml-language-server"];
          }
          {
            name = "toml";
            language-servers = ["taplo"];
          }
          {
            name = "php";
            language-servers = ["intelephense"];
          }
          {
            name = "zig";
            language-servers = ["zls"];
          }
          {
            name = "gdscript";
            language-servers = ["godot"];
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
    zsh = {
      enable = true;
    };
  };

  home.file.".config/helix/themes".source = "${catppuccin-helix}/themes/default";
  home.stateVersion = "23.11";
}
