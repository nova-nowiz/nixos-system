{ stdenv, lib, srcs, emacsGcc, git, findutils, ripgrep, fd, ... }:
stdenv.mkDerivation rec {
  name = "doom-emacs";

  src = srcs.doom-emacs;

  buildInputs = [
    (emacsGcc.override { withXwidgets = true; })
    git
    findutils
    ripgrep
    fd
  ];

  buildPhase = ''
    sh bin/doom install || cat .local/doom.error.log
    ls -la
    ls -la .local
  '';

  installPhase = ''
    cp -r * $out
  '';
}
