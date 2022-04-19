{ self, config, lib, pkgs, options, ... }:
let inherit (lib) fileContents;
in
{
  environment = {
    systemPackages = with pkgs; [
      lightlocker
    ];
  };
  services = {
    xserver = {
      enable = true;
      desktopManager = {
        xterm.enable = false;
        xfce = {
          enable = true;
          enableXfwm = false;
          thunarPlugins = with pkgs.xfce; [
            thunar-volman
            thunar-archive-plugin
          ];
        };
      };
    };
  };
}
