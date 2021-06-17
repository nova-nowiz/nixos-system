{ suites, lib, pkgs, ... }:
{
  ### root password is empty by default ###
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
      "vm.swappiness" = 1;
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

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;

  system.stateVersion = "21.11";
}
