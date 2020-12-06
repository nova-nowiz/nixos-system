# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./themes.nix
      #<musnix> #You have to install musnix: sudo -i nix-channel --add https://github.com/musnix/musnix/archive/master.tar.gz musnix && sudo -i nix-channel --update musnix
    ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = {
      timeout = null;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernel.sysctl = {
      "vm.max_map_count" = 262144;
      "fs.file-max" = 65536;
    };
    kernelModules = [ "kvm-amd" "snd-seq" "snd-rawmidi" ];
    initrd.kernelModules = [ "amdgpu" ];
    extraModulePackages = with config.boot.kernelPackages; [
      v4l2loopback
    ];
    plymouth.enable = true;
  };

  networking = {
    #wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    dhcpcd.wait = "background";

    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Open ports in the firewall.
    firewall = {
      allowedTCPPorts = [ 3389 8069 25565 ];
      allowedUDPPorts = [ 3389 8069 25565 ];
      allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
      allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];
    };
    # Or disable the firewall altogether.
    # firewall.enable = false;
  };



  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # I do not use it as I think every users should install whatever they want to
  # on there own space, and the system should only provide stuff that the user
  # can't install easily, for example the DE.
  environment.systemPackages = with pkgs; [
    xf86_video_nouveau
    sweet
    qtstyleplugin-kvantum-qt4
    qt5.qttools
  ];

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
  };

  system.autoUpgrade.enable = true;

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "Hack" ]; })
    ubuntu_font_family
  ];

  # List services that you want to enable:

  services = {
    # Enable the OpenSSH daemon.
    openssh.enable = true;

    fail2ban = {
      enable = true;
      jails = {
        apache-nohome-iptables = ''
          # Block an IP address if it accesses a non-existent
          # home directory more than 5 times in 10 minutes,
          # since that indicates that it's scanning.
          filter   = apache-nohome
          action   = iptables-multiport[name=HTTP, port="http,https"]
          logpath  = /var/log/httpd/error_log*
          findtime = 600
          bantime  = 600
          maxretry = 5
        '';
      };
      bantime-increment.enable = true;
    };


    # Enable CUPS to print documents.
    printing = {
      enable = true;
      drivers = with pkgs; [
        hplip
      ];
    };

    teamviewer.enable = true;

    #jack = {
    #  jackd.enable = true;
    #  # support ALSA only programs via ALSA JACK PCM plugin
    #  alsa.enable = false;
    #  # support ALSA only programs via loopback device (supports programs like Steam)
    #  loopback = {
    #    enable = true;
    #    # buffering parameters for dmix device to work with ALSA only semi-professional sound programs
    #    #dmixConfig = ''
    #    #  period_size 2048
    #    #'';
    #  };
    #};

    gnome3 = {
      gnome-keyring.enable = true;
      evolution-data-server.enable = true;
    };

    xserver = {
      enable = true;
      # layout = "us";
      # xkbOptions = "eurosign:e";

      libinput.enable = true;

      desktopManager = {
        xterm.enable = false;
        plasma5 = {
          enable = true;
        };
      };

      displayManager = {
        sddm = {
          enable = true;
          extraConfig = ''
            [Autologin]
            User=narice
            Session=plasma5+i3.desktop
          '';
        };
      };

      #videoDrivers = [ "nvidia" ];
      videoDrivers = [ "amdgpu" ]; 

      deviceSection = ''
        Option "TearFree" "true"
      '';

      digimend.enable = true;

      windowManager.i3 = {
        enable = true;
        package = pkgs.i3-gaps;
        extraPackages = with pkgs; [
          rofi
          i3lock-color
          dunst
          libnotify
          nitrogen
          polybarFull
          lxappearance
          pavucontrol
          alacritty
          firefox
          gparted
          kdeApplications.dolphin
          gnome3.gnome-calculator
          libreoffice-fresh
          adapta-gtk-theme
          breeze-gtk
          papirus-icon-theme
       ];
      };
    };
  };

  programs = {
    sway = {
      enable = true;
      extraPackages = with pkgs; [
        mako
        libnotify
        rofi
        swaylock-effects
        swayidle
        swaybg
        waybar
        xwayland
        wl-clipboard
        xorg.xhost
        pavucontrol
        alacritty
        firefox
        gparted
        kdeApplications.dolphin
        gnome3.gnome-calculator
        libreoffice-fresh
        adapta-gtk-theme
        breeze-gtk
        papirus-icon-theme
        v4l-utils
        wf-recorder
      ];
    };

    x2goserver = {
      enable = true;
    };

    zsh = {
      enable = true;
    };

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # mtr.enable = true;
    # gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    #   pinentryFlavor = "gnome3";
    # };
  };

  # Enable sound.
  sound.enable = true;
  hardware = {
    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudio.override { jackaudioSupport = true; };
      support32Bit = true;
    };

    opengl = {
      extraPackages = with pkgs; [ amdvlk ];
      driSupport32Bit = true;
      extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
    };
  };

  #musnix = {
  #  enable = true;
  #  # kernel modifications doesn't seem to work with nvidia dkms
  #  #kernel = {
  #  #  optimize = true;
  #  #  realtime = true;
  #  #};
  #};

  systemd = {
    extraConfig = "DefaultLimitNOFILE=524288";
    user.extraConfig = "DefaultLimitNOFILE=524288";
  };

  security.pam.loginLimits = [
    {
      domain = "narice";
      type = "hard";
      item = "nofile";
      value = "524288";
    }
  ];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-wlr ];
  };

  virtualisation = {
    virtualbox.host.enable = true;
    kvmgt.enable = true;
    libvirtd.enable = true;
    docker.enable = true;
    podman = {
      enable = true;
    };
  };

  users = {
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users = {
      narice = {
        isNormalUser = true;
        extraGroups = [ "wheel" "vboxusers" "kvm" "libvirtd" "docker" "jackaudio" "audio" ]; # Enable ‘sudo’ for the user.
      };

      monasbook = {
        isNormalUser = true;
        extraGroups = [ "vboxusers" "kvm" "libvirtd" "jackaudio" "audio" ];
      };
    };

    defaultUserShell = pkgs.zsh;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?
}
