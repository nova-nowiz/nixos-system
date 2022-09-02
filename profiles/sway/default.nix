{ self, config, lib, pkgs, options, ... }:
let inherit (lib) fileContents;
in
{
  programs = {
    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      extraPackages = with pkgs; [
        swaylock # lockscreen
        swayidle
        mako # notification daemon
        kanshi # autostrada
      ];
    };
  };
}
