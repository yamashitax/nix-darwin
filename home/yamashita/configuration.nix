{ config
, pkgs
, ... }:

{
   users.users."yamashita" = {               # macOS user
     home = "/Users/yamashita";
     shell = pkgs.zsh;                     # Default shell
   };
}
