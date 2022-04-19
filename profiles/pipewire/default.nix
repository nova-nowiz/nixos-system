{ self, config, lib, pkgs, options, ... }:
let inherit (lib) fileContents;
in
{
  sound.enable = false;
  services = {
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
    };
  };
}
