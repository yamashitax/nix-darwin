{ config
, pkgs
, ... }:

{
  users.users."work" = {               # macOS user
    home = "/Users/work";
    shell = pkgs.zsh;                     # Default shell
  };

  system.defaults.dock.persistent-apps = [
    "/Applications/Safari.app"
    "/Users/work/Applications/Home Manager Apps/WezTerm.app"
    "/Users/work/Applications/Home Manager Apps/TablePlus.app"
  ];

  homebrew.casks = [
    "unclack"
    "1password"
    "asana"
    "slack"
  ];
}
