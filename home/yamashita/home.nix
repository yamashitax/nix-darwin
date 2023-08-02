{
  extensions,
  lib, 
  pkgs,
  devenv,
  ... 
}: 
{
  imports = with devenv; [ ../common.nix ];

  programs.git.userEmail = "hello@yamashit.ax";
}