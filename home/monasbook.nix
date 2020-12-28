{ config, pkgs, lib, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "monasbook";
  home.homeDirectory = "/home/monasbook";

  home.packages = with pkgs; [
      wget
      git
      fzf
      neovim
      discord
      exa
      hunspell
      hunspellDicts.en-us
      hunspellDicts.fr-any
      pandoc
      keepassxc
      rhythmbox
      steam
      lutris
      minecraft
      teams
      vscode
      audacity
      ark
      bat
      flameshot
      ghostscript
      krita
      mellowplayer
      mpv
      obs-studio
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
      python39Full
      unar
      unzip
      wine
      xournalpp
      zip
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    # Users Unfree Packages
    "discord"
    "steam"
    "steam-original"
    "steam-runtime"
    "minecraft-launcher"
    "teams"
    "vscode"
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
