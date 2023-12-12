{ self, config, lib, pkgs, options, ... }:
let inherit (lib) fileContents;
in
{
  fonts = {

    fonts = with pkgs; [
      twitter-color-emoji
      noto-fonts-emoji
      hack-nerd-font-ligature
      # (nerdfonts.override { fonts = [ "Hack" ]; })
      ubuntu_font_family
      gyre-fonts
      symbola
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
    ];

    enableDefaultFonts = true;

    fontconfig.defaultFonts = {

      emoji = [ "Twitter Color Emoji" "Noto Color Emoji" ];

      monospace = [ "Hack Nerd Font Mono" ];

      sansSerif = [ "Ubuntu" ];

      serif = [ "TeX Gyre Termes" ];

    };
  };
}
