{ suites, lib, pkgs, ... }:
{
  imports = suites.main;

  networking = {
    hostName = "vm";
    interfaces.wlan0.virtual = true;
    networkmanager = {
      enable = true;
    };
  };

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = false;
    };
  };
  system.stateVersion = "21.11";
}
