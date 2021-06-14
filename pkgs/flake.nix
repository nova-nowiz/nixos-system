{
  description = "Package Sources";

  inputs = {
    zsh-fzf-tab = {
      url = "github:Aloxaf/fzf-tab";
      flake = false;
    };
    zsh-autopair = {
      url = "github:hlissner/zsh-autopair";
      flake = false;
    };
    zsh-nix-shell = {
      url = "github:chisui/zsh-nix-shell";
      flake = false;
    };
    zsh-completions = {
      url = "github:zsh-users/zsh-completions";
      flake = false;
    };
    zsh-you-should-use = {
      url = "github:MichaelAquilina/zsh-you-should-use";
      flake = false;
    };
    zsh-powerlevel10k = {
      url = "github:romkatv/powerlevel10k";
      flake = false;
    };

    candy-icon-theme = {
      url = "github:EliverLara/candy-icons";
      flake = false;
    };

    doom-emacs = {
      url = "github:hlissner/doom-emacs";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, ... }: {
    overlay = final: prev: {
      inherit (self) srcs;
    };

    srcs =
      let
        inherit (nixpkgs) lib;

        mkVersion = name: input:
          let
            inputs = (builtins.fromJSON
              (builtins.readFile ./flake.lock)).nodes;

            ref =
              if lib.hasAttrByPath [ name "original" "ref" ] inputs
              then inputs.${name}.original.ref
              else "";

            version =
              let version' = builtins.match
                "[[:alpha:]]*[-._]?([0-9]+(\.[0-9]+)*)+"
                ref;
              in
              if lib.isList version'
              then lib.head version'
              else if input ? lastModifiedDate && input ? shortRev
              then "${lib.substring 0 8 input.lastModifiedDate}_${input.shortRev}"
              else null;
          in
          version;
      in
      lib.mapAttrs
        (pname: input:
          let
            version = mkVersion pname input;
          in
          input // { inherit pname; }
          // lib.optionalAttrs (! isNull version)
            {
              inherit version;
            }
        )
        (lib.filterAttrs (n: _: n != "nixpkgs")
          self.inputs);
  };
}
