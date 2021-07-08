{ suites, lib, pkgs, ... }:
{
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
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
      kernelModules = [ "amdgpu" ];
    };
    kernel.sysctl = {
      "vm.swappiness" = lib.mkForce 1;
    };
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
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

  fileSystems = {
    "/" = {
      label = "nixos-root";
      fsType = "ext4";
    };

    "/home" = {
      label = "nixos-home";
      fsType = "ext4";
    };

    "/boot" = {
      label = "BOOT";
      fsType = "vfat";
    };

    "/nix/store" = {
      label = "nix-store";
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

  powerManagement.cpuFreqGovernor = lib.mkForce "powersave";
  # high-resolution display
  hardware.video.hidpi.enable = true;

  system.stateVersion = "21.11";
}
