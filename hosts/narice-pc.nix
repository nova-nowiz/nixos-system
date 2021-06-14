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
    };
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
    # zfs.enableUnstable = true;
  };

  services = {
    xserver = {
      videoDrivers = [ "amdgpu" ];
    };
  };

  hardware = {
    opengl = {
      extraPackages = with pkgs; [ amdvlk ];
    };
  };

  fileSystems = {
    "/" = {
      label = "nixos-root";
      fsType = "ext4";
    };
    "/nix/store" = {
      label = "nixos-store";
      fsType = "ext4";
    };
    "/boot" = {
      label = "BOOT";
      fsType = "vfat";
    };
    "/home" = {
      label = "nixos-home";
      fsType = "ext4";
    };
    "/home/narice/vault" = {
      label = "vault-narice";
      fsType = "ext4";
    };
    # "/home/monasbook/vault" = {
    #   label = "vault-monasbook";
    #   fsType = "ext4";
    # };
    "/home/narice/shared" = {
      label = "shared";
      fsType = "ext4";
    };
    # "/home/monasbook/shared" = {
    #   device = "/home/narice/shared";
    #   fsType = "none";
    #   options = [ "bind" ];
    # };
  };

  swapDevices = [
    { label = "swap"; }
  ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;

  system.stateVersion = "21.11";
}
