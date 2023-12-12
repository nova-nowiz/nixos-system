{ self, config, lib, pkgs, options, ... }:
let inherit (lib) fileContents;
in
{
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-volman
      thunar-archive-plugin
    ];
  };
}
