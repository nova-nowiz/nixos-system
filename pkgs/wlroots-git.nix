{ lib
, stdenv
, fetchFromGitLab
, meson
, ninja
, pkg-config
, wayland-scanner
, libGL
, wayland
, wayland-protocols
, libinput
, libxkbcommon
, pixman
, xcbutilwm
, libX11
, libcap
, xcbutilimage
, xcbutilerrors
, mesa
, libpng
, ffmpeg_4
, xcbutilrenderutil
, seatd
, vulkan-loader
, glslang
, nixosTests

, enableXWayland ? true
, xwayland ? null
}:

stdenv.mkDerivation rec {
  pname = "wlroots";
  version = "unstable-23-04-2022";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "wlroots";
    repo = "wlroots";
    rev = "03c88b07ba64185de7183f52f5f3e4875c5c1d5d";
    sha256 = "sha256-xM8DuTaV+N0DAuKcGeMJinKAqhk2coXlt9OqxHYF3jw=";
  };

  # $out for the library and $examples for the example programs (in examples):
  outputs = [ "out" "examples" ];

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [ meson ninja pkg-config wayland-scanner glslang ];

  buildInputs = [
    libGL
    wayland
    wayland-protocols
    libinput
    libxkbcommon
    pixman
    xcbutilwm
    libX11
    libcap
    xcbutilimage
    xcbutilerrors
    mesa
    libpng
    ffmpeg_4
    xcbutilrenderutil
    seatd
    vulkan-loader
  ]
  ++ lib.optional enableXWayland xwayland
  ;

  mesonFlags =
    lib.optional (!enableXWayland) "-Dxwayland=disabled"
  ;

  postFixup = ''
    # Install ALL example programs to $examples:
    # screencopy dmabuf-capture input-inhibitor layer-shell idle-inhibit idle
    # screenshot output-layout multi-pointer rotation tablet touch pointer
    # simple
    mkdir -p $examples/bin
    cd ./examples
    for binary in $(find . -executable -type f -printf '%P\n' | grep -vE '\.so'); do
      cp "$binary" "$examples/bin/wlroots-$binary"
    done
  '';

  # Test via TinyWL (the "minimum viable product" Wayland compositor based on wlroots):
  passthru.tests.tinywl = nixosTests.tinywl;

  meta = with lib; {
    description = "A modular Wayland compositor library";
    longDescription = ''
      Pluggable, composable, unopinionated modules for building a Wayland
      compositor; or about 50,000 lines of code you were going to write anyway.
    '';
    inherit (src.meta) homepage;
    changelog = "https://gitlab.freedesktop.org/wlroots/wlroots/-/tags/${version}";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos synthetica ];
  };
}
