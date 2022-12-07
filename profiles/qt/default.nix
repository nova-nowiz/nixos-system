{ self, config, lib, pkgs, options, ... }:
let inherit (lib) fileContents;
in
{
  qt5 = {
    # TODO: make a note of it in a wiki or a manual
    enable = true;
    style = "gtk2";
    platformTheme = "gtk2";
  };
}
