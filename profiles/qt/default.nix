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
  programs = {
    qt5ct.enable = true;
  };
  environment.variables.QT_QPA_PLATFORMTHEME = lib.mkForce "qt5ct";
}
