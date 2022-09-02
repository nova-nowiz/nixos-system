{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, libdrm
, libinput
, libxcb
, libxkbcommon
, mesa
, pango
, wayland
, wayland-protocols
, wlroots
, xcbutilwm
}:

stdenv.mkDerivation rec {
  pname = "hyprland";
  version = "unstable-29-04-2022";

  src = fetchFromGitHub {
    owner = "vaxerski";
    repo = pname;
    rev = "0132e52b1351a93fd7017e9653caa4aab419ca87";
    sha256 = "Y/BhaLeGuVaZQCSUIYZ9gEHvG8Jwmp5jvivlkKy1LnA=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config

    wayland
  ];

  buildInputs = [
    libdrm
    libinput
    libxcb
    libxkbcommon
    mesa
    pango
    wayland-protocols
    wlroots
    xcbutilwm
  ];

  postPatch = ''
    make config
  '';

  postBuild = ''
    pushd ../hyprctl
    g++ -std=c++20 -w ./main.cpp -o ./hyprctl
    popd
  '';

  installPhase = ''
    mkdir -p $out/bin
    install Hyprland $out/bin
    install -m755 ../hyprctl/hyprctl $out/bin

    mkdir -p $out/share/wayland-sessions
    cp ../example/hyprland.desktop $out/share/wayland-sessions
  '';

  passthru.providedSessions = [ "hyprland" ];

  meta = with lib; {
    homepage = "https://github.com/vaxerski/Hyprland";
    description = "A dynamic tiling Wayland compositor that doesn't sacrifice on its looks";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
