{ suites, lib, pkgs, ... }:
{
  ### root password is empty by default ###
  imports = suites.base;


  networking = {
    interfaces.eno1.useDHCP = true;
    networkmanager.enable = true;
  };

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd = {
      # Corresponds to NixOS's first boot stage
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "ext4" ];
      kernelModules = [ "amdgpu" "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "ext4" ];
      supportedFilesystems = [ "ext4" ];
    };
    kernel.sysctl = {
      "vm.swappiness" = 1;
    };
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
    # zfs.enableUnstable = true;
  };

  services = {
    xserver = {
      videoDrivers = [ "amdgpu" ];
    };
    fstrim.enable = true;
  };

  hardware = {
    opengl = {
      extraPackages = with pkgs; [ amdvlk ];
    };
  };

  # fileSystems = {
  #   "/" = {
  #     label = "nixos-root";
  #     fsType = "ext4";
  #   };
  #   "/nix/store" = {
  #     label = "nixos-store";
  #     fsType = "ext4";
  #   };
  #   "/boot" = {
  #     label = "BOOT";
  #     fsType = "vfat";
  #   };
  #   "/home" = {
  #     label = "nixos-home";
  #     fsType = "ext4";
  #   };
  #   "/home/narice/vault" = {
  #     label = "vault-narice";
  #     fsType = "ext4";
  #   };
  #   # "/home/monasbook/vault" = {
  #   #   label = "vault-monasbook";
  #   #   fsType = "ext4";
  #   # };
  #   "/home/narice/shared" = {
  #     label = "shared";
  #     fsType = "ext4";
  #   };
  #   # "/home/monasbook/shared" = {
  #   #   device = "/home/narice/shared";
  #   #   fsType = "none";
  #   #   options = [ "bind" ];
  #   # };
  # };

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/40628186-dfa5-40b1-a50e-590b70ea828f";
      fsType = "ext4";
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/7f1e3c57-24a7-469e-bfb2-d6a7960f6510";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/A947-9FE6";
      fsType = "vfat";
    };

  fileSystems."/nix/store" =
    { device = "/dev/disk/by-uuid/fccf1661-82dd-422e-8858-e2470742db76";
      fsType = "ext4";
    };

  swapDevices = [
    { label = "swap"; }
  ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;

  system.stateVersion = "21.11";
}
