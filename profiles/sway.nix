{ self, config, lib, pkgs, options, ... }:
let inherit (lib) fileContents;
in
{
  programs = {
    sway = {
      enable = true;
      package = pkgs.sway;
      wrapperFeatures.gtk = true;
      extraPackages = with pkgs; [
        swaylock # lockscreen
        swayidle
        mako # notification daemon
        kanshi # autostrada
      ];
    };
  };
  xdg = {
    mime.enable = true;
    icons.enable = true;
    portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
  };
}
