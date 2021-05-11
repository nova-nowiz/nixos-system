{ config, pkgs, lib, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "narice";
  home.homeDirectory = "/home/narice";

  home.packages = with pkgs; [
      ark
      bat
      chessx
      discord
      docker-compose
      (emacs.override { withXwidgets = true; })
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
      gnome3.seahorse
      hardinfo
      htop
      hunspell
      hunspellDicts.en-us
      hunspellDicts.fr-any
      imagemagick
      insomnia
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

  nixpkgs.config = {
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      # Users Unfree Packages
      "discord"
      "minecraft-launcher"
      "slack"
      "steam"
      "steam-original"
      "steam-runtime"
      "teams"
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
      teams = super.teams.overrideAttrs (old: {
        version = "1.3.00.30857";
        src = super.fetchurl {
          url = "https://packages.microsoft.com/repos/ms-teams/pool/main/t/teams/teams_1.3.00.30857_amd64.deb";
          sha256 = "06r48h1fr2si2g5ng8hsnbcmr70iapnafj21v5bzrzzrigzb2n2h";
        };
      });
      ardour = super.ardour.overrideAttrs (old: {
        version = "6.5";
        src = super.fetchgit {
          url = "git://git.ardour.org/ardour/ardour.git";
          sha256 = "0sd38hchyr16biq9hcxha4ljy3pf0yhcgn90i5zfqcznnc57ildx";
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
