{ self, config, lib, pkgs, options, ... }:
let inherit (lib) fileContents;
in
{
  services = {
    blueman.enable = true;
  };
  hardware = {
    pulseaudio.enable = false;
  };
}
