{ self, config, lib, pkgs, options, ... }:
let inherit (lib) fileContents;
in
{
  programs.hyprland = {
    enable = true;
  };
}
