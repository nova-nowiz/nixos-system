{ config, lib, pkgs, ... }:

{
  services.redshift = {
    enable = true;
  };
}
