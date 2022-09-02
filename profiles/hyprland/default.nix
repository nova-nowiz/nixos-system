{ self, config, lib, pkgs, options, ... }:
let inherit (lib) fileContents;
in
{
  environment = {
    systemPackages = [ pkgs.hyprland ];
  };
  security.pam.services.swaylock = { };
  hardware.opengl.enable = lib.mkDefault true;
  fonts.enableDefaultFonts = lib.mkDefault true;
  programs.dconf.enable = lib.mkDefault true;
  # To make an Hyprland session available if a display manager like SDDM is enabled:
  services.xserver.displayManager.sessionPackages = [ pkgs.hyprland ];
  programs.xwayland.enable = lib.mkDefault true;
  # For screen sharing (this option only has an effect with xdg.portal.enable):
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
  xdg.portal.enable = lib.mkDefault true;
}
