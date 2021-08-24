{ suites, lib, pkgs, ... }:
{
  imports = suites.base;

  networking = {
    interfaces.wlp0s20f3.useDHCP = true;
    networkmanager.enable = true;
  };

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd = {
      # Corresponds to NixOS's first boot stage
      availableKernelModules = [ "xhci_pci" "thunderbolt" "vmd" "nvme" "usb_storage" "sd_mod" ];
      kernelModules = [ ];
    };
    kernel.sysctl = {
      "vm.swappiness" = lib.mkForce 1;
    };
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
  };

  services = {
    fstrim.enable = true;
    xserver = {
      libinput = {
        enable = true;
	touchpad = {
	  tapping = true;
	  tappingDragLock = true;
	  scrollMethod = "twofinger";
	  disableWhileTyping = false;
	};
      };
      
      desktopManager.gnome.enable = true;
    };
  };

  hardware = {
    opengl = {
      enable = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        rocm-opencl-icd
        rocm-opencl-runtime
      ];
      extraPackages32 = with pkgs; [
        pkgsi686Linux.libva
      ];
    };
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
  # high-resolution display
  hardware.video.hidpi.enable = true;

  system.stateVersion = "21.11";
}
