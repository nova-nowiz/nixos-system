{ suites, lib, pkgs, ... }:
{
  imports = [./astraea.nix];

  networking = {
    interfaces.wlan0.virtual = true;
  };
}
