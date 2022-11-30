{ stdenv, lib, srcs, ... }:
let
  inherit (srcs)
    hack-nerd-font-ligature;
in
stdenv.mkDerivation {
  pname = "hack-nerd-font-ligature";
  version = "20221129";
  src = hack-nerd-font-ligature;
  dontUnpack = true;
  installPhase = ''
    fonts="$out/share/fonts/truetype/NerdFonts/"
    mkdir -p "$fonts"
    cp $src/font/*.ttf "$fonts"
  '';
}
