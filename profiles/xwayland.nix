{ self, config, lib, pkgs, options, ... }:
let inherit (lib) fileContents;
in
{
  programs = {
    xwayland.enable = true;
  };
}
