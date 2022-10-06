{ suites, lib, pkgs, ... }:
{
  imports = suites.default;

  networking = {
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
