{ self, config, lib, pkgs, options, ... }:
let inherit (lib) fileContents;
in
{
  services = {
    xserver = {
      enable = true;
      displayManager = {
        gdm = {
          enable = true;
        };
      };
    };
  };
  security.pam = {
    services = {
      gdm.gnupg.enable = true;
    };
  };
  users.users.gdm.shell = lib.mkForce pkgs.zsh;
}
