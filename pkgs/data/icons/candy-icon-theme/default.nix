{ stdenv, lib, srcs, breeze-icons, gtk3, gnome-icon-theme, hicolor-icon-theme, mint-x-icons, pantheon }:
stdenv.mkDerivation rec {
  pname = "candy-icons";

  src = srcs.candy-icon-theme;

  nativeBuildInputs = [
    gtk3
  ];

  propagatedBuildInputs = [
    breeze-icons
    gnome-icon-theme
    pantheon.elementary-icon-theme
    hicolor-icon-theme
    mint-x-icons
  ];

  dontDropIconThemeCache = true;

  installPhase = ''
    theme="$out/share/icons/${pname}"
    mkdir -p $theme
    cp -r * $theme
    gtk-update-icon-cache $theme
  '';
}
