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
      #ripcord
      exa
      bottom
      dust
      fd
      ripgrep
      ripgrep-all
      korganizer
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
      #vscodium
      podman-compose
      docker-compose
      audacity
      bat
      cadence
      conan
      corectrl
      cmake
      gnome3.evolution
      exfat
      feh
      flameshot
      gcc
      ghc
      ghostscript
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
      obs-studio
      obs-wlrobs
      ocaml
      kdeApplications.okular
      olive-editor
      opam
      openjdk14
      pciutils
      perl
      psensor
      python39Full
      qjackctl
      radeon-profile
      rustup
      saxon
      scons
      tree
      unzip
      vagrant
      wine
      xorg.xev
      xournalpp
      zathura
      zip
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
