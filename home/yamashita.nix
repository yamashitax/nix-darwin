{ pkgs, lib, ... }:

{
  home.stateVersion = "23.05";
  programs = {
    git = {
      enable = true;
      userName = "山下";
      userEmail = "hello@yamashit.ax";
    };
    kitty = {
      enable = true;
      extraConfig = builtins.readFile ../shared/kitty;
    };
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;

      extraLuaConfig = ''
        ${lib.strings.fileContents ../shared/init.lua}
      '';
    };
  };
}
