{ lib, stdenv, srcs, fetchFromGitHub, breeze-icons, gtk3, gnome-icon-theme, hicolor-icon-theme, mint-x-icons, pantheon }:

stdenv.mkDerivation rec {
  pname = "candy-icons";
  version = "0.0.1";

  src = srcs.candy-icon-theme;

  nativeBuildInputs = [ gtk3 ];

  # ubuntu-mono is also required but missing in ubuntu-themes (please add it if it is packaged at some point)
  propagatedBuildInputs = [
    breeze-icons
    gnome-icon-theme
    hicolor-icon-theme
    mint-x-icons
    pantheon.elementary-icon-theme
  ];

  dontDropIconThemeCache = true;

  installPhase = ''
    mkdir -p $out/share/icons/${pname}
    cp -r * $out/share/icons/${pname}/
    gtk-update-icon-cache $out/share/icons/${pname}
  '';
}
