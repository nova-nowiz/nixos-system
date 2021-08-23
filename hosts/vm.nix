{ suites, lib, pkgs, ... }:
{
  imports = suites.base;


  networking = {
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
      enable = true;
      driSupport32Bit = true;
    };
  };

  powerManagement.cpuFreqGovernor = lib.mkForce "powersave";
  # high-resolution display
  hardware.video.hidpi.enable = true;

  system.stateVersion = "21.11";
}
