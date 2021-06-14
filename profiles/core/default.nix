{ self, config, lib, pkgs, options, modulesPath, ... }:
let inherit (lib) fileContents;
in
{
  imports = [ ../cachix ./sddm.nix (modulesPath + "/installer/scan/not-detected.nix") ];

  environment = {
    systemPackages = with pkgs; [
      binutils
      coreutils
      curl
      direnv
      dnsutils
      dosfstools
      fd
      git
      gotop
      gptfdisk
      iputils
      jq
      manix
      moreutils
      nix-index
      nmap
      pulseaudio
      carla
      qjackctl
      ripgrep
      skim
      tealdeer
      usbutils
      utillinux
      whois
      exa
      fzf
      bat
    ];

    sessionVariables = {
      # FZF variables
      FZF_BASE = "${pkgs.fzf}/share/fzf";
      FZF_BASE_COMMAND =
        "fd --color=always --hidden --follow --exclude .git";
      FZF_BASE_OPTS =
        "--ansi --preview 'bat --style=numbers --color=always --line-range :500 {}'";

      FZF_COMPLETION_OPTS = "$FZF_BASE_OPTS";

      FZF_DEFAULT_COMMAND = "$FZF_BASE_COMMAND --type f";
      FZF_DEFAULT_OPTS = "$FZF_BASE_OPTS";

      FZF_CTRL_T_COMMAND = "$FZF_BASE_COMMAND --type f";
      FZF_CTRL_T_OPTS = "$FZF_BASE_OPTS";

      FZF_CTRL_R_OPTS = "--ansi --preview ''";

      FZF_ALT_C_COMMAND = "$FZF_BASE_COMMAND --type d";
      FZF_ALT_C_OPTS = "--ansi --preview 'exa -1 --color=always {}'";
    };
  };

  #my stuff

  boot = {
    loader = {
      timeout = null;
    };
    kernel.sysctl = {
      "vm.max_map_count" = 262144;
      "fs.file-max" = 65536;
    };
    plymouth.enable = true;
  };

  networking = {
    dhcpcd.wait = "background";
    firewall = {
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
    };
  };

  i18n.defaultLocale = "en_US.UTF-8";

  nix = {

    package = pkgs.nixUnstable;

    systemFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];

    autoOptimiseStore = true;

    gc.automatic = true;

    trustedUsers = [ "root" "@wheel" ];

    extraOptions = ''
      experimental-features = nix-command flakes
      min-free = 536870912
      keep-outputs = true
      keep-derivations = true
      fallback = true
    '';
  };

  fonts = {
    fonts = with pkgs; [
      (nerdfonts.override { fonts = [ "Hack" ]; })
      ubuntu_font_family
    ];

    fontconfig.defaultFonts = {

      monospace = [ "Hack Nerd Font" ];

      sansSerif = [ "Ubuntu Sans" ];

    };
  };

  services = {
    xserver = {
      enable = true;

      displayManager = {
        sddm.enable = true;
      };

      desktopManager = {
        xterm.enable = false;
        plasma5.enable = true;
      };

      windowManager.i3 = {
        enable = true;
        package = pkgs.i3-gaps;
        extraPackages = with pkgs; [
          nitrogen
          alacritty
        ];
      };

      deviceSection = ''
        Option "TearFree" "true"
      '';

      digimend.enable = true;
    };

    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
    };

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

    printing = {
      enable = true;
      drivers = with pkgs; [
        hplip
      ];
    };

    picom = {
      enable = true;
      backend = "glx";
      fade = true;
      fadeDelta = 5;
      vSync = true;
      shadow = false;
      shadowOffsets = [ 0 0 ];
      opacityRules = [
        # basically I'll have to put applications that are not references, but input things in there
        "80:class_g = 'Alacritty' && !_NET_WM_STATE@:32a && !focused"
        "80:class_g = 'Emacs' && !_NET_WM_STATE@:32a && !focused"
        "0:_NET_WM_STATE@:32a *= '_NET_WM_STATE_HIDDEN'"
      ];
      settings = {
        experimental-backends = true;
        corner-radius = 10;
        rounded-corners-exclude = [
          #"class_g = 'i3-frame'"
          "class_g = 'plasmashell'"
        ];
        round-borders = 1;
        frame-opacity = 0.7;
        blur = {
          method = "kawase";
          strength = 3;
          background = false;
          background-frame = false;
          background-fixed = false;
          kern = "3x3box";
        };
        blur-background-exclude = [ "class_g = 'Peek'" ];
        mark-wmwin-focused = true;
        detect-rounded-corners = true;
        detect-client-opacity = true;
        detect-transient = true;
        detect-client-leader = true;
        log-level = "info";
      };
    };

    dbus.packages = with pkgs; [ gnome3.dconf ]; # for home-manager to not crash
  };

  programs = {
    zsh = {
      enable = true;
      histSize = 100000;
      autosuggestions.enable = true;
      syntaxHighlighting = {
        enable = true;
        highlighters = [ "main" "brackets" "pattern" "cursor" ];
      };
      ohMyZsh = {
        enable = true;
        plugins = [
          "git"
          "colorize"
          "direnv"
          "sudo"
          "fzf"
          "autopair"
          "nix-shell"
          "zsh-completions"
          "you-should-use"
          "fzf-tab" # at the end to be sure that ^I is bound to it
        ];
        theme = "powerlevel10k/powerlevel10k";
        custom = "${pkgs.ohMyZshCustom}";
      };
    };
    dconf.enable = true;
  };

  hardware = {
    opengl = {
      enable = true;
      driSupport32Bit = true;
      extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
    };
    steam-hardware.enable = true;
  };

  systemd = {
    extraConfig = "DefaultLimitNOFILE=524288";
    user.extraConfig = "DefaultLimitNOFILE=524288";
  };

  security.pam = {
    services = {
      kwallet.enableKwallet = true;
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

  virtualisation = {
    kvmgt.enable = true;
    libvirtd.enable = true;
    docker.enable = true;
  } //
  (lib.optionalAttrs (builtins.hasAttr "qemu" options.virtualisation) {
    memorySize = 16 * 1024;
    msize = 16 * 1024;
    cores = 8;
    qemu = {
      # TODO: can we make it so the resolution is not crap?
      # -g doesn't work sdl doesn't work gl=on is necessary
      # maybe it's a driver issue?
      # nope, qxl doesn't work (resolution problem)
      # qxl+spice is really bad
      # virtio+axrandr for managing res is really good but not at startup
      # screenfetch
      options = [
        "-vga virtio"
        "-display gtk,gl=on"
        "-cpu host"
        "-enable-kvm"
        "-audiodev pa,id=usb,out.mixing-engine=off"
        "-device usb-audio,audiodev=usb,multi=on"
      ];
    };
  });

  qt5 = {
    # TODO: make a note of it in a wiki or a manual
    enable = true;
    style = "gtk2";
    platformTheme = "gtk2";
  };

  users = {
    defaultUserShell = pkgs.zsh;
  };
}
