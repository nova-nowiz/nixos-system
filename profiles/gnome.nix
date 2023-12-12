{ self, config, lib, pkgs, options, ... }:
let inherit (lib) fileContents;
in
{
  services = {
    xserver = {
      enable = true;
      desktopManager = {
        xterm.enable = false;
        gnome.enable = true;
      };
    };
  };
}
