{ config, pkgs, lib, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "narice";
  home.homeDirectory = "/home/narice";

  home.packages = with pkgs; [
      android-studio
      appimage-run
      ark
      aseprite
      audacity
      bat
      #bottom # not in 20.09
      cmake
      conan
      #corectrl # not in 20.09
      discord
      docker-compose
      #dust
      element-desktop
      (emacs.override { withXwidgets = true; })
      exa
      exfat
      fd
      feh
      ffmpeg
      flameshot
      fzf
      ghostscript
      git
      git-crypt
      gnome3.seahorse
      gnumake
      godot
      hardinfo
      htop
      hunspell
      hunspellDicts.en-us
      hunspellDicts.fr-any
      imagemagick
      inkscape
      jdk
      kdeApplications.akonadi
      kdeApplications.akonadi-calendar
      kdeApplications.akonadi-contacts
      kdeApplications.akonadi-import-wizard
      kdeApplications.akonadi-mime
      kdeApplications.akonadi-notes
      kdeApplications.akonadi-search
      kdeApplications.calendarsupport
      kdeApplications.kalarm
      kdeApplications.kalarmcal
      kdeApplications.kdeconnect-kde
      kdeApplications.kidentitymanagement
      kdeApplications.kmail
      kdeApplications.kmailtransport
      kdeApplications.kontact
      kdeApplications.korganizer
      kdeApplications.ksmtp
      kdeApplications.okular
      keepassxc
      killall
      krita
      libtool
      lm_sensors
      mellowplayer
      minecraft
      mpv
      neofetch
      neovim
      ninja
      nix-index
      nix-prefetch
      nix-prefetch-github
      nmap
      nodejs
      ntfs3g
      obs-studio
      obs-wlrobs
      ocaml
      olive-editor
      opam
      pandoc
      pciutils
      peek
      podman-compose
      procs
      psensor
      (python39Full.withPackages(p: with p; [ pygments ]))
      qjackctl
      radeon-profile
      ranger
      razergenie
      rhythmbox
      ripgrep
      ripgrep-all
      rnix-lsp
      rustup
      saxon
      scons
      steam
      sway-contrib.grimshot
      tealdeer
      teams
      (texlive.combine
        { inherit (texlive) 
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
        ;}
      )
      tokei
      tree
      unar
      unzip
      virt-manager
      vscode
      w3m
      wev
      wget
      wine
      xclip
      xorg.xev
      xournalpp
      youtube-dl
      zathura
      zip
      zoom
  ];

  nixpkgs.config = {
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      # Users Unfree Packages
      "android-studio-stable"
      "discord"
      "steam"
      "steam-original"
      "steam-runtime"
      "minecraft-launcher"
      "teams"
      "idea-ultimate"
      "vscode"
      "zoom"
    ];

    packageOverrides = super: {
      razergenie = super.razergenie.overrideAttrs (old: {
        version = "0.9.0";
        src = super.fetchFromGitHub {
          owner = "z3ntu";
          repo = "RazerGenie";
          rev = "v0.9.0";
          sha256 = "17xlv26q8sdbav00wdm043449pg2424l3yaf8fvkc9rrlqkv13a4";
        };
      });
    };
  };

  programs = {
    direnv = {
      enable = true;
      enableNixDirenvIntegration = true;
    };
  };

  services = {
    kdeconnect = {
      enable = true;
      indicator = true;
    };
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "20.09";
}
