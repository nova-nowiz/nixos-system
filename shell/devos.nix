{ pkgs, extraModulesPath, inputs, lib, ... }:
let

  inherit (pkgs)
    agenix
    cachix
    editorconfig-checker
    mdbook
    nixUnstable
    nixpkgs-fmt
    nvfetcher-bin
    ;

  hooks = import ./hooks;

  pkgWithCategory = category: package: { inherit package category; };
  devos = pkgWithCategory "devos";
  linter = pkgWithCategory "linter";
  docs = pkgWithCategory "docs";

in
{
  _file = toString ./.;

  imports = [ "${extraModulesPath}/git/hooks.nix" ];
  git = { inherit hooks; };

  # tempfix: remove when merged https://github.com/numtide/devshell/pull/123
  devshell.startup.load_profiles = pkgs.lib.mkForce (pkgs.lib.noDepEntry ''
    # PATH is devshell's exorbitant privilige:
    # fence against its pollution
    _PATH=''${PATH}
    # Load installed profiles
    for file in "$DEVSHELL_DIR/etc/profile.d/"*.sh; do
      # If that folder doesn't exist, bash loves to return the whole glob
      [[ -f "$file" ]] && source "$file"
    done
    # Exert exorbitant privilige and leave no trace
    export PATH=''${_PATH}
    unset _PATH
  '');

  commands = [
    (devos nixUnstable)
    (devos agenix)

    {
      category = "devos";
      name = nvfetcher-bin.pname;
      help = nvfetcher-bin.meta.description;
      command = "cd $PRJ_ROOT/pkgs; ${nvfetcher-bin}/bin/nvfetcher -c ./sources.toml $@";
    }
    {
      category = "tools";
      name = "dry";
      help = "Test if your config builds! | usage: dry <config>";
      command = "nixos-rebuild dry-activate --flake .#$@";
    }
    {
      category = "tools";
      name = "dry-build";
      help = "Test what will build! | usage: dry-build <config>";
      command = "nixos-rebuild dry-build --flake .#$@";
    }
    {
      category = "tools";
      name = "switch";
      help = "Makes rebuilding easy! | usage: switch <config>";
      command = "sudo nixos-rebuild switch --flake .#$@";
    }
    {
      category = "tools";
      name = "update";
      help = "Update an input to a flake! | usage: update <input>";
      command = "nix flake lock --update-input $@";
    }

    (linter nixpkgs-fmt)
    (linter editorconfig-checker)

    (docs mdbook)
  ]
  ++ lib.optionals (!pkgs.stdenv.buildPlatform.isi686) [
    (devos cachix)
  ]
  ++ lib.optionals (pkgs.stdenv.hostPlatform.isLinux && !pkgs.stdenv.buildPlatform.isDarwin) [
    (devos inputs.nixos-generators.defaultPackage.${pkgs.system})
    (devos inputs.deploy.packages.${pkgs.system}.deploy-rs)
  ]
  ;
}
