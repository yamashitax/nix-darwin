{
  extensions,
  lib, 
  pkgs,
  ... 
}: 
{
  imports = [ ../common.nix ];

  programs.git.userEmail = "hello@yamashit.ax";
}