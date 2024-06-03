{
  extensions,
  lib, 
  pkgs,
  ... 
}: 
{
  imports = [ ../common.nix ];

  programs = {
    jujutsu.settings.user = {
      name = "山下";
      email = "git@yamashit.ax";
    };

    git.userEmail = "hello@yamashit.ax";
  };
}
