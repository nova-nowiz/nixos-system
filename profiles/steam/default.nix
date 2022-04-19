{ self, config, lib, pkgs, options, ... }:
let inherit (lib) fileContents;
in
{
  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };
  };
  hardware = {
    steam-hardware.enable = true;
  };
}
