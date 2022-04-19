{ self, config, lib, pkgs, options, ... }:
let inherit (lib) fileContents;
in
{
  services = {
    printing = {
      enable = true;
      drivers = with pkgs; [
        hplip
      ];
    };
  };
}
