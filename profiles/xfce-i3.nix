{ self, config, lib, pkgs, options, ... }:
let inherit (lib) fileContents;
in
{
  services = {
    xserver = {
      displayManager = {
        defaultSession = "xfce+i3";
      };
    };
  };
}
