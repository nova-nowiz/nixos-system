{ self, config, lib, pkgs, options, ... }:
let inherit (lib) fileContents;
in
{
  musnix = {
    enable = true;
    # kernel = {
    #   optimize = true;
    #   realtime = true;
    #   packages = pkgs.linuxPackages_latest_rt;
    # };
  };
}
