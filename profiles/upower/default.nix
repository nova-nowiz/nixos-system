{ self, config, lib, pkgs, options, ... }:
{
  services.upower = {
    enable = true;
    percentageCritical = 5;
    percentageAction = 4;
  };
}
