{
  extensions,
  lib, 
  pkgs,
  devenv,
  zig,
  ... 
}: let
  marketplace-extensions = with extensions.extensions.${pkgs.system}.vscode-marketplace; [
    bokuweb.vscode-ripgrep
    evgeniypeshkov.syntax-highlighter 
    ifaxity.onedark
    sourcegraph.cody-ai
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
        "extensions.autoUpdate" = false;
        "editor.fontFamily" = "JetBrains Mono";
        "editor.fontLigatures" = true;
        "editor.fontSize" = 10;
        "vim.leader" = "<space>";
        "vim.hlsearch" = true;
        "vim.useSystemClipboard" = true;
        "vim.smartRelativeLine" = true;
        "vim.highlightedyank.enable" = true;
        "workbench.colorTheme" = "OneLight++";
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