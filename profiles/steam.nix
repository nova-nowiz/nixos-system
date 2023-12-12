{ self, config, lib, pkgs, options, ... }:
let inherit (lib) fileContents;
in
{
  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      gamescopeSession.enable = true;
    };
    gamescope.enable = true;
  };
  hardware = {
    steam-hardware.enable = true;
  };
}
