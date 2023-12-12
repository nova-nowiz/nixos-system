{ self, config, lib, pkgs, options, ... }:
let inherit (lib) fileContents;
in
{
  environment.systemPackages = with pkgs.gnome; [
    gnome-calculator
    gnome-calendar
    gnome-characters
    gnome-clocks
    gnome-disk-utility
    gnome-font-viewer
    gnome-maps
    gnome-music
    gnome-system-monitor
    gnome-weather
    cheese
    baobab
    eog
  ] ++ (with pkgs; [
    # gnome circle so it still counts x)
    textpieces
    warp
  ]);
}
