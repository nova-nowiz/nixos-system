channels: final: prev: {

  __dontExport = true; # overrides clutter up actual creations

  inherit (channels.latest)
    # discord # now using flatpak
    ;

  inherit (channels.unstable)
    cachix
    element-desktop
    # emacsPgtkNativeComp
    gtklock
    manix
    rage
    steam
    # qutebrowser # flatpak
    # yuzu # flatpak
    yuzu-ea;


  haskellPackages = prev.haskellPackages.override
    (old: {
      overrides = prev.lib.composeExtensions (old.overrides or (_: _: { })) (hfinal: hprev:
        let version = prev.lib.replaceChars [ "." ] [ "" ] prev.ghc.version;
        in
        {
          # same for haskell packages, matching ghc versions
          inherit (channels.latest.haskell.packages."ghc${version}")
            haskell-language-server;
        });
    });

  # TODO: move it to its own overlay
  # TODO: have the src as a flake...
  picom = prev.picom.overrideAttrs (hprev: {
    version = "ibhagwan";
    src = prev.fetchFromGitHub {
      owner = "ibhagwan";
      repo = "picom";
      rev = "60eb00ce1b52aee46d343481d0530d5013ab850b";
      sha256 = "sha256-PDQnWB6Gkc/FHNq0L9VX2VBcZAE++jB8NkoLQqH9J9Q=";
    };
  });
}
