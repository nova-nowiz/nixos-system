{ self, config, lib, pkgs, options, ... }:
let inherit (lib) fileContents;
in
{
  services = {
    xserver = {
      libinput = {
        enable = true;
        touchpad = {
          tapping = true;
          tappingDragLock = true;
          scrollMethod = "twofinger";
          naturalScrolling = true;
          disableWhileTyping = false;
        };
      };
    };
  };
}
