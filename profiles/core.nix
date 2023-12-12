{ self, config, lib, pkgs, options, ... }:
let inherit (lib) fileContents;
in
{
  # TODO: check the systemPackages
  # TODO: split everything of into profiles
  environment = {
    systemPackages = with pkgs; [
      # shell essentials
      bat
      curl
      exa
      fd
      git
      bottom
      nmap
      ripgrep
      tealdeer

      binutils
      carla
      coreutils
      direnv
      dnsutils
      dosfstools
      gptfdisk
      iputils
      manix
      moreutils
      nix-index
      pulseaudio
      qjackctl
      skim
      usbutils
      utillinux
      whois
    ];
    shells = [ pkgs.zsh ];
  };

  #my stuff

  boot = {
    loader = {
      timeout = lib.mkForce null;
    };
    kernel.sysctl = {
      "vm.max_map_count" = 262144;
      "fs.file-max" = 65536;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    plymouth.enable = true;
  };

  networking = {
    dhcpcd.wait = "background";
    firewall = {
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
      allowedTCPPortRanges = [{ from = 1714; to = 1764; }];
      allowedUDPPortRanges = [{ from = 1714; to = 1764; }];
    };
  };

  hardware.enableRedistributableFirmware = true;

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_CTYPE = "fr_FR.UTF-8";
      LC_NUMERIC = "fr_FR.UTF-8";
      LC_TIME = "fr_FR.UTF-8";
      LC_COLLATE = "fr_FR.UTF-8";
      LC_MONETARY = "fr_FR.UTF-8";
      LC_MESSAGES = "fr_FR.UTF-8";
      LC_PAPER = "fr_FR.UTF-8";
      LC_NAME = "fr_FR.UTF-8";
      LC_ADDRESS = "fr_FR.UTF-8";
      LC_TELEPHONE = "fr_FR.UTF-8";
      LC_MEASUREMENT = "fr_FR.UTF-8";
      LC_IDENTIFICATION = "fr_FR.UTF-8";
    };
  };
  time.timeZone = "Europe/Paris";

  nix = {

    package = pkgs.nixUnstable;

    gc.automatic = true;

    settings = {
      trusted-users = [ "root" "@wheel" ];
      system-features = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      auto-optimise-store = true;
    };

    extraOptions = ''
      experimental-features = nix-command flakes
      min-free = 536870912
      keep-outputs = true
      keep-derivations = true
      fallback = true
    '';
  };
  # nix = {

  #   package = pkgs.nixUnstable;

  #   systemFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];

  #   autoOptimiseStore = true;

  #   gc.automatic = true;

  #   trustedUsers = [ "root" "@wheel" ];

  #   extraOptions = ''
  #     experimental-features = nix-command flakes
  #     min-free = 536870912
  #     keep-outputs = true
  #     keep-derivations = true
  #     fallback = true
  #   '';
  # };

  services = {
    # TODO: research rage encryption
    openssh.enable = true;
    flatpak.enable = true;
    udisks2.enable = true;

    dbus.packages = with pkgs; [ dconf ]; # for home-manager to not crash
  };

  programs = {
    gnupg.agent = {
      enable = true;
      # pinentryFlavor = "gnome3";
    };
    dconf.enable = true;
    nm-applet.enable = true;
  };

  systemd = {
    extraConfig = "DefaultLimitNOFILE=524288";
    user.extraConfig = "DefaultLimitNOFILE=524288";
  };

  security = {
    polkit.enable = true;
    pam = {
      services = {
        kwallet.enableKwallet = true;
        gtklock = { };
      };
      loginLimits = [
        {
          domain = "narice";
          type = "hard";
          item = "nofile";
          value = "524288";
        }
      ];
    };
  };
}
