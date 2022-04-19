{ self, config, lib, pkgs, options, ... }:
let inherit (lib) fileContents;
in
{
  services = {
    xserver = {
      enable = true;
      displayManager = {
        lightdm = {
          enable = true;
          background = ./background.png;
          greeters.enso = {
            enable = true;
            blur = true;
            theme = {
              package = pkgs.materia-theme;
              name = "Materia-dark-compact";
              # package = pkgs.sweet;
              # name = "Sweet-Dark";
            };
            iconTheme = {
              package = pkgs.papirus-icon-theme;
              name = "Papirus";
              # package = pkgs.candy-icon-theme;
              # name = "candy-icons";
            };
            cursorTheme = {
              package = pkgs.qogir-icon-theme;
              name = "Qogir";
            };
            extraConfig = "user-background=false";
          };
        };
      };
    };
  };
  security.pam = {
    services = {
      lightdm.gnupg.enable = true;
    };
  };
  users.users.lightdm.shell = lib.mkForce pkgs.zsh;
}
