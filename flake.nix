{
  description = "Heyooooo, amma do some OS here, don't mind meeeeee";

  inputs = {
    stable.url = "nixpkgs/nixos-23.05";
    unstable.url = "nixpkgs/nixos-unstable";
    latest.url = "nixpkgs/master";


    home.url = "github:nix-community/home-manager/release-23.05";
    home.inputs.nixpkgs.follows = "stable";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    flake-parts.url = "github:hercules-ci/flake-parts";
    colmena.url = "github:zhaofengli/colmena";
    haumea.url = "github:nix-community/haumea";

    devshell.url = "github:numtide/devshell";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    agenix.url = "github:ryantm/agenix";

    pkgs-flake.url = "path:./pkgs";
    pkgs-flake.inputs.nixpkgs.follows = "stable";

    # emacs.url = "github:nix-community/emacs-overlay/49e3c66d211d5110909375fe48d85c3c43753d61";

    musnix-flake.url = "github:musnix/musnix";
    # hyprland-flake.url = "github:Narice/Hyprland/22cdf0580b6cbdc5d20920358c99560bfc109c7d";
    hyprland-flake.url = "github:hyprwm/Hyprland";
    wpaperd-flake.url = "github:Narice/wpaperd";
    wpaperd-flake.inputs.nixpkgs.follows = "stable";
    waybar-flake.url = "github:Narice/Waybar/my-main";
    waybar-flake.inputs.nixpkgs.follows = "stable";
  };

  outputs =
    inputs@
    { self
    , stable
    , unstable
    , latest
    , home
    , nixos-hardware
    , flake-parts
    , colmena
    , haumea
    , devshell
    , treefmt-nix
    , agenix
    , pkgs-flake
      # , emacs
    , musnix-flake
    , hyprland-flake
    , wpaperd-flake
    , waybar-flake
    , ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; }
      ({ moduleWithSystem, ... }: {
        imports = [
          devshell.flakeModule
          treefmt-nix.flakeModule
        ];

        systems = [
          "x86_64-linux"
          "aarch64-linux"
        ];

        debug = true;

        perSystem =
          { config
          , self'
          , inputs'
          , pkgs
          , system
          , ...
          }: {
            _module.args.pkgs = import stable {
              inherit system;
              config.allowUnfreePredicate =
                pkg: builtins.elem (stable.lib.getName pkg) [
                  # Unfree Fonts
                  "symbola"
                  # Narice Unfree Packages
                  "discord"
                  "minecraft-launcher"
                  "slack"
                  "steam"
                  "steam-run"
                  "steam-original"
                  "steam-runtime"
                  "teams"
                  "widevine"
                  "yuzu-mainline"
                  "yuzu-ea"
                  "zoom"
                ];
              overlays = [
                agenix.overlays.default

                # emacs.overlays.default
                hyprland-flake.overlays.default
                wpaperd-flake.overlays.default
                waybar-flake.overlays.default

                pkgs-flake.overlay
                (import ./pkgs)
              ];
            };

            treefmt = {
              programs. alejandra. enable = true;
              flakeFormatter = true;
              projectRootFile = "flake.nix";
            };

            devshells.default = { pkgs, ... }: {
              commands = [
                { package = pkgs.nixUnstable; }
                { package = inputs'.agenix.packages.default; }
                { package = inputs'.colmena.packages.colmena; }
                {
                  category = "tools";
                  name = "switch";
                  help = "Makes rebuilding easy! | usage: switch";
                  command = "colmena apply-local --sudo --show-trace";
                }
                {
                  category = "tools";
                  name = "update";
                  help = "Update inputs of your flake lock! | usage: update {<input>,<input>,...} (don't put spaces)";
                  command = "nix flake lock --update-input $@";
                }
                {
                  category = "tools";
                  name = "update-all";
                  help = "Update all inputs of your flake lock! | usage: update <input>";
                  command = "nix flake update";
                }
              ];
            };
          };

        flake = {
          userProfiles = haumea.lib.load {
            src = ./users/profiles;
            loader = haumea.lib.loaders.path;
          };

          userSuites =
            let
              suites = self.userSuites;
            in
            with self.userProfiles; {
              base = [
                direnv
                git
              ];
              all = stable.lib.flatten [
                suites.base
                ardour
              ];
            };

          userConfigs = {
            root = ./users/root/default.nix;
            narice = ./users/narice/default.nix;
          };

          nixosModules = {
            # bla = ./modules/bla.nix
          };

          nixosProfiles = haumea.lib.load {
            src = ./profiles;
            loader = haumea.lib.loaders.path;
          };

          nixosSuites =
            let
              suites = self.nixosSuites;
              users = self.userConfigs;
            in
            with self.nixosProfiles; {
              base = [
                core
                cachix.default
                users.narice
                users.root
              ];
              minimal = stable.lib.flatten [
                suites.base

                # session manager
                lightdm.default

                # WM
                hyprland

                # essentials
                virtualization
                keyboard
                touchpad
                fonts
                pipewire
                bluetooth
                upower
                gnome-keyring

                # making eveything usable
                printing
                graphic-tablet

                # important apps
                thunar
                zsh
              ];
              main = stable.lib.flatten [
                suites.minimal

                musnix
                qt

                # cool apps
                gnome-apps
                steam

                # backup wayland session
                sway
                # note: gnome is not usable with hyprland/sway because of gnome's xdg portal

                # backup x11 DE
                # i3
                # picom
                # xfce
                # xfce-i3
              ];
              all = stable.lib.flatten [
                suites.base
                bluetooth
                fail2ban
                fonts
                fzf
                # gdm
                gnome
                graphic-tablet
                hyprland
                # i3
                keyboard
                lightdm.default
                # location
                musnix
                # picom
                pipewire
                printing
                qt
                # redshift
                steam
                sway
                thunar
                touchpad
                virtualization
                # xfce
                # xfce-i3
                xwayland
                zsh
              ];
              wayland = stable.lib.flatten [
                suites.base
                bluetooth
                fail2ban
                fonts
                fzf
                gdm.default
                graphic-tablet
                hyprland
                keyboard
                musnix
                pipewire
                printing
                qt
                steam
                thunar
                touchpad
                virtualization
                xwayland
                zsh
              ];
            };

          colmena = {
            meta = {
              nixpkgs = import stable {
                system = "x86_64-linux";
                config.allowUnfreePredicate =
                  pkg: builtins.elem (stable.lib.getName pkg) [
                    # Unfree Fonts
                    "symbola"
                    # Narice Unfree Packages
                    "discord"
                    "minecraft-launcher"
                    "slack"
                    "steam"
                    "steam-run"
                    "steam-original"
                    "steam-runtime"
                    "teams"
                    "widevine"
                    "yuzu-mainline"
                    "yuzu-ea"
                    "zoom"
                  ];
                overlays = [
                  agenix.overlays.default

                  # emacs.overlays.default
                  hyprland-flake.overlays.default
                  wpaperd-flake.overlays.default
                  waybar-flake.overlays.default

                  pkgs-flake.overlay
                  (import ./pkgs)
                ];
              };
              specialArgs.suites = self.nixosSuites;
              specialArgs.usrSuites = self.userSuites;
            };

            defaults = moduleWithSystem (
              perSystem @
              { inputs'
              , self'
              }: { lib, ... }: {
                imports = [
                  agenix.nixosModules.default
                  home.nixosModules.home-manager
                  musnix-flake.nixosModules.musnix
                  hyprland-flake.nixosModules.default
                ]
                ++ lib.attrValues self.nixosModules;
                _module.args = {
                  inputs = perSystem.inputs';
                  self = self // perSystem.self'; # to preserve original attributes in self like outPath
                };
                deployment = {
                  buildOnTarget = true;
                  targetUser = null;
                  allowLocalDeployment = true;
                };
              }
            );
            narice-pc = { ... }: {
              imports = [
                ./hosts/narice-pc.nix
              ];
            };
            astraea = { ... }: {
              imports = [
                ./hosts/astraea.nix
                nixos-hardware.nixosModules.dell-xps-13-9310
              ];
            };
            vm = { ... }: {
              imports = [
                ./hosts/vm.nix
              ];
            };
          };
        };
      });
}
