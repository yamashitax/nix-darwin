{
  extensions,
  lib, 
  pkgs,
  ... 
}: 
{
  imports = [ ../common.nix ];

  home.packages = with pkgs; [
    bun
    fd
    nodePackages.intelephense
    rectangle
    sensible-side-buttons
    tableplus
  ];
}
