{ self, config, lib, pkgs, options, ... }:
let inherit (lib) fileContents;
in
{
  fonts = {
    fonts = with pkgs; [
      (nerdfonts.override { fonts = [ "Hack" ]; })
      ubuntu_font_family
    ];

    fontconfig.defaultFonts = {

      monospace = [ "Hack Nerd Font" ];

      sansSerif = [ "Ubuntu Sans" ];

    };
  };
}
