{ ... }:
{
  home-manager.users.narice = { suites, pkgs, lib, nixos, ... }: {
    imports = suites.base;

    home.packages = with pkgs; [
      ark
      audacity
      bat
      chessx
      discord
      docker-compose
      libsForQt5.dolphin
      element-desktop
      exa
      exfat
      fd
      feh
      flameshot
      freerdp
      fzf
      ghostscript
      git
      git-crypt
      gnome3.gnome-calculator
      gnome3.seahorse
      gparted
      hardinfo
      htop
      hunspell
      hunspellDicts.en-us
      hunspellDicts.fr-any
      imagemagick
      insomnia
      korganizer
      okular
      keepassxc
      killall
      krita
      libreoffice-fresh
      libtool
      lm_sensors
      lxappearance
      mellowplayer
      minecraft
      mpv
      neofetch
      neovim
      nix-du
      nix-index
      nix-prefetch
      nix-prefetch-github
      nmap
      ntfs3g
      obs-studio
      obs-wlrobs
      olive-editor
      pandoc
      pciutils
      peek
      procs
      psensor
      radeon-profile
      ranger
      razergenie
      rhythmbox
      ripgrep
      ripgrep-all
      rnix-lsp
      slack-dark
      steam
      sway-contrib.grimshot
      tealdeer
      teams
      (texlive.combine
        {
          inherit (texlive)
            capt-of
            catchfile
            chktex
            dvisvgm
            etoolbox
            fancyvrb
            float
            fontspec
            framed
            fvextra
            ifplatform
            kvoptions
            latexmk
            lineno
            lipsum
            minted
            needspace
            pdftexcmds
            scheme-tetex
            titlepic
            titlesec
            upquote
            wrapfig
            xcolor
            xstring
            ;
        }
      )
      tokei
      tree
      unar
      unzip
      virt-manager
      w3m
      wev
      wget
      wine
      x2goclient
      xclip
      xorg.xev
      xournalpp
      youtube-dl
      zathura
      zip
      zoom-us
    ];

    programs = {
      emacs = {
        enable = true;
        package = ((pkgs.emacsGcc.override { withXwidgets = true; }).pkgs.withPackages (epkgs: with epkgs; [
          vterm
          pdf-tools # FIXME: installing pdf-tools like this doesn't work
        ]));
        # extraPackages = (epkgs: with epkgs; [ vterm pdf-tools ]);
      };

      alacritty.enable = true;
      firefox.enable = true;
      qutebrowser.enable = true;
    };

    services = {
      kdeconnect = {
        enable = true;
        indicator = true;
      };

      emacs = {
        enable = true;
        client.enable = true;
      };
    };

    xdg.configFile =
      let
        config = ./dotfiles/xdg;
      in
      {
        "alacritty".source = "${config}/alacritty";
        "i3".source = "${config}/i3";
        "zathura".source = "${config}/zathura";
        "nvim".source = "${config}/nvim";
        "background".source = "${config}/background";
        "xfce4" = {
          source = "${config}/xfce4";
          recursive = true;
        };
        # This fixed dolphin not following the background set by the gtk theme
        "kdeglobals".text = ''
          [Colors:View]
          BackgroundNormal=22,25,37
        '';
      };

    home.file =
      let
        home = ./dotfiles/home;
        doom = ./dotfiles/doom;
        config = ./dotfiles/xdg;
        bin = ./dotfiles/bin;
      in
      {
        ".face.icon".source = "${home}/.face.icon";
        ".gitconfig".source = "${home}/.gitconfig";
        ".p10k.zsh".source = "${home}/.p10k.zsh";
        ".vimrc".source = "${home}/.vimrc";
        ".zshrc".source = "${home}/.zshrc";
        ".doom.d" = {
          source = "${doom}";
          recursive = true;
        };
        ".local/bin" = {
          source = "${bin}";
          recursive = true;
        };
        ".xournalpp" = {
          source = "${home}/xournalpp";
          recursive = true;
        };
      };

    gtk = {
      enable = true;
      font = {
        package = pkgs.ubuntu_font_family;
        name = "Ubuntu";
        size = 12;
      };
      # FIXME: not applied correctly on xfce
      iconTheme = {
        package = pkgs.candy-icon-theme;
        name = "candy-icons";
      };
      theme = {
        package = pkgs.sweet; # TODO: add murrine engine to gtk | opened issue on it
        name = "Sweet-Dark";
      };
    };

    qt = {
      enable = true;
      platformTheme = "gtk";
      style.name = "gtk2";
    };

    home.sessionVariables = {
      TERMINAL = "alacritty";
      EDITOR = "emacsclient -cn";
      VISUAL = "emacsclient -cn";
      NIX_BUILD_SHELL = "${pkgs.zsh}/bin/zsh";
      PATH = "$PATH:$HOME/.emacs.d/bin:$HOME/.local/bin";
    };

    xsession = {
      enable = true;
      windowManager.command = ''
        ${pkgs.i3-gaps}/bin/i3 &
        waitPID=$!


        # Start the desktop manager.
        ${pkgs.bash}/bin/bash ${pkgs.xfce.xfce4-session}/etc/xdg/xfce4/xinitrc &
        waitPID=$!


        ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd --all


        test -n "$waitPID" && wait "$waitPID"

        /run/current-system/systemd/bin/systemctl --user stop graphical-session.target

        exit 0
      '';
      # FIXME: pointerCursor config not taken into account
      pointerCursor = {
        package = pkgs.qogir-icon-theme;
        name = "Qogir";
      };
    };

    xresources.extraConfig = (builtins.readFile ./dotfiles/home/challenger-deep-xresources) + ''

      URxvt.font: xft:Hack Nerd Font:size=12
      URxvt.depth: 32

      XTerm*faceName: Hack Nerd Font
      XTerm*faceSize: 12

      Xft.dpi: 96
      Xft.antialias: true
      Xft.hinting: true
      Xft.rgba: rgb
      Xft.autohint: false
      Xft.hintstyle: hintslight
      Xft.lcdfilter: lcddefault
    '';

    # TODO: firefox config?
    # TODO: discord config?
    # TODO: mellowdream config?
    # TODO: keepass config? probably unsafe
    # TODO: change lock mechanism to light-lock
  };

  users.users.narice = {
    uid = 1000;
    description = "default";
    isNormalUser = true;
    extraGroups = [ "wheel" "kvm" "libvirtd" "docker" "audio" ];
    hashedPassword =
      "$6$Gdi6PgGv5c/NLe$Xcp9rJ8MZZetBiuhoy2C0LU8KhHXj3PwLVUjlsKx9/GPaveAXH53gOHBNu8Fp0DQqqR1xpr1tg7yZEF7X7crA0";
  };
}
