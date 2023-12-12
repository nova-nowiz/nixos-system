{ self, config, lib, pkgs, options, ... }:
let inherit (lib) fileContents;
in
{
  programs = {
    zsh = {
      enable = true;
      histSize = 100000;
      autosuggestions.enable = true;
      syntaxHighlighting = {
        enable = true;
        highlighters = [ "main" "brackets" "pattern" "cursor" ];
        styles = {
          "cursor" = "bold";
        };
      };
      ohMyZsh = {
        enable = true;
        plugins = [
          "git"
          "colorize"
          "direnv"
          "sudo"
          "fzf"
          "autopair"
          "nix-shell"
          "zsh-completions"
          "you-should-use"
          "fzf-tab" # at the end to be sure that ^I is bound to it
        ];
        theme = "powerlevel10k/powerlevel10k";
        custom = "${pkgs.ohMyZshCustom}";
      };
    };
  };
  users = {
    defaultUserShell = pkgs.zsh;
  };
}
