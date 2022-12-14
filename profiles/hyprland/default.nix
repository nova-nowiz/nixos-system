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
      # updateDbusEnvironment = true;
    };
    accounts-daemon.enable = true;
  };
  xdg = {
    mime.enable = true;
    icons.enable = true;
    portal = {
      enable = true;
      wlr.enable = false;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
  };
}
