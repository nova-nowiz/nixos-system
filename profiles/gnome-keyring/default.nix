{ self, config, lib, pkgs, options, ... }:
let inherit (lib) fileContents;
in
{
  services = {
    gnome = {
      gnome-keyring.enable = true;
    };
  };
  programs.seahorse.enable = true;
}
