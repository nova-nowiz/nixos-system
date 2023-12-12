{ self, config, lib, pkgs, options, ... }:
let inherit (lib) fileContents;
in
{
  # services = {
  #   xserver = {
  #     digimend.enable = true;
  #   };
  # };
  hardware.opentabletdriver.enable = true;
}
