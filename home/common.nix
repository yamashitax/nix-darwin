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

  copilot = pkgs.writeShellApplication {
    name = "copilot";
    text = ''
      ${pkgs.nodejs-slim}/bin/node ${pkgs.vimPlugins.copilot-vim}/dist/agent.js "''$@" 
    '';
  };

  # newpr = pkgs.writeShellApplication {
  #   name = "newpr";
  #   text = ''
  #     set -euo pipefail

  #     readonly pr_commit="main"

  #     # Autogenerate a branch name based on the commit subject.
  #     readonly branch_name="$(${pkgs.git} show --no-patch --format="%f" "$pr_commit")"

  #     # Create the new branch and switch to it.
  #     ${pkgs.git} branch --no-track "$branch_name" origin/main
  #     ${pkgs.git} switch "$branch_name"

  #     # Cherry pick the desired commit.
  #     if ! ${pkgs.git} cherry-pick "$pr_commit"; then
  #         ${pkgs.git} cherry-pick --abort
  #         ${pkgs.git} switch main
  #         exit 1
  #     fi

  #     # Create a new remote branch by the same name.
  #     ${pkgs.git} -c push.default=current push

  #     # Go back to main branch.
  #     ${pkgs.git} switch main
  #   '';
  # };

  # updatepr = pkgs.writeShellApplication {
  #   name = "updatepr";
  #   text = ''
  #     set -euo pipefail

  #     if [[ $# -ne 1 ]]; then
  #         echo "usage: $0 <pr-commit>" 2>&1
  #         exit
  #     fi

  #     readonly pr_commit="$(${pkgs.git} rev-parse HEAD)"

  #     readonly branch_name="$(${pkgs.git} show --no-patch --format="%f" "$pr_commit")"

  #     ${pkgs.git} switch "$branch_name"

  #     # Cherrypick the latest commit to the PR branch.
  #     if ! ${pkgs.git} cherry-pick main; then
  #         ${pkgs.git} cherry-pick --abort
  #         ${pkgs.git} switch main
  #         exit 1
  #     fi

  #     # Push the updated branch.
  #     ${pkgs.git} push

  #     # Go back to main.
  #     ${pkgs.git} switch main

  #     # This allows for scripted (non-interactive) use of interactive rebase.
  #     export GIT_SEQUENCE_EDITOR=/usr/bin/true

  #     # In two steps, squash the latest commit into its PR commit.
  #     # 1. Mark the commit as a fixup
  #     ${pkgs.git} commit --amend --fixup="$pr_commit"
  #     # 2. Use the autosquash feature of interactive rebase to perform the squash.
  #     ${pkgs.git} rebase --interactive --autosquash "${pr_commit}^"
  #   '';
  # };
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
      package = pkgs.helix;
      settings = {
        theme = "catppuccin_latte";

        editor = {
          line-number = "relative";
          mouse = true;
          bufferline = "multiple";
          true-color = true;
          color-modes = true;
          auto-format = true;
          auto-save = true;

          indent-guides.render = true;

          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };

          file-picker = {
            hidden = false;
          };

          lsp = {
            auto-signature-help = false;
            display-messages = true;
            display-inlay-hints = true;
            # copilot-auto = true;
          };

          statusline = {
            left = ["mode" "spinner" "version-control" "file-name"];
            right = ["file-type" "file-encoding"];
            mode.normal = "NORMAL";
            mode.insert = "INSERT";
            mode.select = "SELECT";
          };

          soft-wrap = {
            enable = true;
          };
        };

        keys = {
          # insert = {
          #   right = "apply_copilot_completion";
          # };
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
          copilot = {
            command = "${copilot}/bin/copilot";
            args = ["--stdio"];
          };
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
            language-servers = ["nil" "copilot"];
            auto-format = true;
          }
          {
            name = "rust";
            language-servers = ["rust-analyzer" "copilot"];
          }
          {
            name = "lua";
            language-servers = ["lua-language-server" "copilot"];
          }
          {
            name = "javascript";
            language-servers = ["typescript-language-server" "copilot"];
          }
          {
            name = "typescript";
            language-servers = ["typescript-language-server" "copilot"];
          }
          {
            name = "bash";
            language-servers = ["bash-language-server" "copilot"];
          }
          {
            name = "hcl";
            language-servers = ["terraform-ls" "copilot"];
          }
          {
            name = "tfvars";
            language-servers = ["terraform-ls" "copilot"];
          }
          {
            name = "go";
            language-servers = ["gopls" "copilot"];
          }
          {
            name = "nu";
            language-servers = ["nu-lsp" "copilot"];
          }
          {
            name = "css";
            language-servers = ["vscode-css-language-server" "copilot"];
          }
          {
            name = "html";
            language-servers = ["vscode-html-language-server" "copilot"];
          }
          {
            name = "nickel";
            language-servers = ["copilot"];
          }
          {
            name = "yaml";
            language-servers = ["yaml-language-server" "copilot"];
          }
          {
            name = "toml";
            language-servers = ["taplo" "copilot"];
          }
          {
            name = "just";
            language-servers = ["copilot"];
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

    vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        github.copilot
        github.copilot-chat
        bmewburn.vscode-intelephense-client
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "cody-ai";
          publisher = "sourcegraph";
          version = "1.1.1704822233";
          sha256 = "sha256-/UyoZfs/euUBK7R66706NR7HU+kOwgR7FxvtBTAuAD8=";
        }
        {
          name = "prism";
          publisher = "usernamehw";
          version = "1.2.0";
          sha256 = "sha256-BCRSTWcdXnoRm7WKworCYrzIfPQ1Ho/vupjRQfyUZI0=";
        }
        # "editor.lineHeight": 1.5,
        # "editor.minimap.renderCharacters": false,
        # "workbench.tips.enabled": false,
        # "terminal.integrated.minimumContrastRatio": 2.5,
        {
          name = "vscode-kakoune";
          publisher = "reykjalin";
          version = "1.3.1";
          sha256 = "sha256-79nINsgLYRdzikcZshubGt7xMDprlJ246zQejrr3vN0=";
        }
        
      ];
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
  home.stateVersion = "23.11";
}
