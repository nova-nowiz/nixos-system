final: prev: rec {
  ohMyZshCustom = prev.callPackage ./ohMyZshCustom.nix { };
  candy-icon-theme = prev.callPackage ./candy-icon-theme.nix { };
  doom-emacs = prev.callPackage ./doom-emacs.nix { };
  widevine-cdm = prev.callPackage ./widevine-cdm.nix { };
  # hyprland = prev.callPackage ./hyprland.nix { wlroots = wlroots-git; };
  # wlroots-git = prev.callPackage ./wlroots-git.nix { inherit (prev.xorg) xcbutilrenderutil; };
}
