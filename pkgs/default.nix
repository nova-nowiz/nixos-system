final: prev: {
  ohMyZshCustom = prev.callPackage ./ohMyZshCustom.nix { };
  candy-icon-theme = prev.callPackage ./candy-icon-theme.nix { };
  doom-emacs = prev.callPackage ./doom-emacs.nix { };
}
