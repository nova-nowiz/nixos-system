{ self, config, lib, pkgs, options, ... }:
let inherit (lib) fileContents;
in
{
  services = {
    xserver = {
      layout = "fr";
      xkbVariant = "us";

      # extraLayouts = {
      #   eurkey-cmk-dh-ansi = {
      #     description = "EurKEY (Colemak-DH, ANSI)";
      #     symbolsFile = ;
      #   };
      #   eurkey-cmk-dh-iso = {
      #     description = "EurKEY (Colemak-DH, ISO)";
      #     symbolsFile = ;
      #   };
      # };
    };
  };
}
