{ config, pkgs, lib, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "narice";
  home.homeDirectory = "/home/narice";

  home.packages = with pkgs; [
      wget
      git
      tridactyl-native
      fzf
      ranger
      neovim
      discord
      exa
      #bottom # not in 20.09
      #dust
      fd
      ripgrep
      ripgrep-all
      hunspell
      hunspellDicts.en-us
      hunspellDicts.fr-any
      pandoc
      emacs
      htop
      keepassxc
      killall
      rhythmbox
      w3m
      wev
      steam
      lutris
      minecraft
      teams
      aseprite
      dotnet-sdk
      dotnet-netcore
      idea.idea-ultimate
      vscode
      podman-compose
      docker-compose
      android-studio
      ark
      audacity
      bat
      conan
      #corectrl # not in 20.09
      cloc
      cmake
      gnome3.evolution
      exfat
      feh
      flameshot
      gcc
      ghc
      ghostscript
      git-crypt
      gnumake
      godot
      sway-contrib.grimshot
      hardinfo
      imagemagick
      krita
      lm_sensors
      love
      lua
      lxappearance
      maven
      mellowplayer
      mono
      ninja
      nix-index
      nix-prefetch
      nmap
      nodejs
      ntfs3g
      mpv
      obs-studio
      obs-wlrobs
      ocaml
      kdeApplications.akonadi
      kdeApplications.akonadi-calendar
      kdeApplications.akonadi-contacts
      kdeApplications.akonadi-import-wizard
      kdeApplications.akonadi-mime
      kdeApplications.akonadi-notes
      kdeApplications.akonadi-search
      kdeApplications.calendarsupport
      kdeApplications.okular
      kdeApplications.kalarm
      kdeApplications.kalarmcal
      kdeApplications.kdeconnect-kde
      kdeApplications.kidentitymanagement
      kdeApplications.kmail
      kdeApplications.kmailtransport
      kdeApplications.kontact
      kdeApplications.korganizer
      kdeApplications.ksmtp
      olive-editor
      opam
      jdk
      pciutils
      perl
      psensor
      python39Full
      qjackctl
      radeon-profile
      razergenie
      rustup
      saxon
      scons
      texlive.combined.scheme-tetex
      tree
      unar
      unzip
      vagrant
      virt-manager
      vlc
      wine
      xorg.xev
      xournalpp
      youtube-dl
      zathura
      zip
      zoom
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
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
