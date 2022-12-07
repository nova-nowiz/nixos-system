{ self, config, lib, pkgs, options, ... }:
let inherit (lib) fileContents;
in
{
  programs.hyprland = {
    enable = true;
  };
  services = {
    xserver = {
      displayManager = {
        defaultSession = "hyprland";
      };
    };
  };
}
