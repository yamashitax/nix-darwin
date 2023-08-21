{ config, pkgs, ... }:

{
  users.users."work" = {      # macOS user
    home = "/Users/work";
    shell = pkgs.zsh;       # Default shell
  };

  homebrew.casks = [
    "brave-browser"
    "rapidapi"
    "sublime-merge"
    "tableplus"
    "sensiblesidebuttons"
  ];
}