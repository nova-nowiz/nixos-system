{ self, config, lib, pkgs, options, ... }:
let inherit (lib) fileContents;
in
{
  services = {
    xserver = {
      enable = true;
      windowManager.i3 = {
        enable = true;
        package = pkgs.i3-gaps;
        extraPackages = with pkgs; [
          nitrogen
          alacritty
        ];
      };
    };
  };
}
