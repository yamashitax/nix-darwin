{
  extensions,
  lib, 
  pkgs,
  devenv,
  zig,
  ... 
}: let
  marketplace-extensions = with extensions.extensions.${pkgs.system}.vscode-marketplace; [
    bbenoist.nix
    bokuweb.vscode-ripgrep
    evgeniypeshkov.syntax-highlighter 
    sourcegraph.cody-ai
    usernamehw.prism
    ziglang.vscode-zig
    tatosjb.fuzzy-search
  ]; 
in {
  home.packages = with pkgs; [
    devenv.packages.aarch64-darwin.devenv
    fd
    rectangle
    zig.packages."${pkgs.system}".master
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

    vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        vscodevim.vim
      ] ++ marketplace-extensions;
      mutableExtensionsDir = true; 
      package = pkgs.vscodium;
      userSettings = {
        # Editor
        "editor.fontFamily" = "JetBrains Mono";
        "editor.fontLigatures" = true;
        "editor.fontSize" = 10;
        "editor.lineHeight" = 1.5;
        "editor.minimap.renderCharacters" = false;
        # Extensions
        "extensions.autoUpdate" = false;
        # Vim
        "vim.highlightedyank.enable" = true;
        "vim.hlsearch" = true;
        "vim.leader" = "<space>";
        "vim.smartRelativeLine" = true;
        "vim.useSystemClipboard" = true;
        "vim.normalModeKeyBindingsNonRecursive" = [
          {
            "before" = ["<leader>" "s" "f"];
            "commands" = ["extension.fuzzySearch"];
          }
          {
            "before" = ["<leader>" "s" "d" "a"];
            "commands" = ["extension.ripgrep"];
          }
          {
            "before" = ["K"];
            "commands" = ["editor.action.showHover"];
          }
          {
            "before" = ["<C-w>"];
            "commands" = ["workbench.action.terminal.toggleTerminal"];
          }
        ];
        # Workbench
        "workbench.colorTheme" = "Prism (No Bold)";
        "workbench.tips.enabled" = false;
      };
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
  };
  
  home.stateVersion = "23.05";
}