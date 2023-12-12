{ suites, lib, pkgs, ... }:
{
  imports = suites.main;

  networking = {
    hostName = "astraea";
    interfaces.wlan0.useDHCP = true;
    networkmanager = {
      enable = true;
    };
  };

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = false;
    };
    initrd = {
      # Corresponds to NixOS's first boot stage
      availableKernelModules = [ "xhci_pci" "thunderbolt" "vmd" "nvme" "usb_storage" "sd_mod" ];
      kernelModules = [ "i915" ];
    };
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
  };

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode = true;
  hardware.opengl.extraPackages = with pkgs; [
    vaapiIntel
    vaapiVdpau
    libvdpau-va-gl
    intel-media-driver
    intel-compute-runtime
  ];
  services.fwupd.enable = true;
  musnix.kernel.packages = pkgs.linuxPackages_latest; # For hardware reasons

  services = {
    fstrim.enable = true;
  };

  fileSystems = {
    "/" = {
      label = "nixos";
      fsType = "ext4";
    };

    "/boot" = {
      label = "BOOT";
      fsType = "vfat";
    };

    "/nix" = {
      label = "nix";
      fsType = "ext4";
    };

    "/home/narice/vault" = {
      label = "vault";
      fsType = "ext4";
    };
  };

  swapDevices = [
    { label = "swap"; }
  ];

  powerManagement.cpuFreqGovernor = lib.mkForce "powersave";

  system.stateVersion = "21.11";
}
