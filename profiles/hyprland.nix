{ self, config, lib, pkgs, options, ... }:
let inherit (lib) fileContents;
in
{
  programs.hyprland = {
    enable = true;
    xwayland = {
      enable = true;
      hidpi = true;
    };
  };
  services = {
    xserver = {
      displayManager = {
        defaultSession = lib.mkDefault "hyprland";
      };
      # updateDbusEnvironment = true;
    };
    accounts-daemon.enable = true;
  };
  xdg = {
    mime.enable = true;
    icons.enable = true;
    portal = {
      # extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
  };
}
