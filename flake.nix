{
  # config primarly based on divnix/devos/f88acc1 and updated to divnix/devos/079adc4 then updated to divnix/digga/examples/devos/24cb8eb
  description = "A highly structured configuration database.";

  nixConfig.extra-experimental-features = "nix-command flakes";
  nixConfig.extra-substituters = "https://nrdxp.cachix.org https://nix-community.cachix.org";
  nixConfig.extra-trusted-public-keys = "nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";

  inputs =
    {
      nixos.url = "nixpkgs/nixos-22.05";
      unstable.url = "nixpkgs/nixos-unstable";
      latest.url = "nixpkgs/master";

      digga.url = "github:divnix/digga";
      digga.inputs.nixpkgs.follows = "nixos";
      digga.inputs.nixlib.follows = "nixos";
      digga.inputs.home-manager.follows = "home";
      digga.inputs.deploy.follows = "deploy";

      darwin.url = "github:LnL7/nix-darwin";
      darwin.inputs.nixpkgs.follows = "latest";

      home.url = "github:nix-community/home-manager/release-22.05";
      home.inputs.nixpkgs.follows = "nixos";

      deploy.url = "github:serokell/deploy-rs";
      deploy.inputs.nixpkgs.follows = "nixos";

      # TODO: research and use it
      agenix.url = "github:ryantm/agenix";
      agenix.inputs.nixpkgs.follows = "nixos";

      nvfetcher.url = "github:berberman/nvfetcher";
      nvfetcher.inputs.nixpkgs.follows = "nixos";

      naersk.url = "github:nmattia/naersk";
      naersk.inputs.nixpkgs.follows = "nixos";

      nixos-hardware.url = "github:nixos/nixos-hardware";

      nixos-generators.url = "github:nix-community/nixos-generators";

      pkgs.url = "path:./pkgs";
      pkgs.inputs.nixpkgs.follows = "nixos";

      emacs.url = "github:nix-community/emacs-overlay/8707d84ec67b39d5655929fc974055bcb9a160fb";

      musnix-flake.url = "github:musnix/musnix";
      hyprland-flake.url = "github:vaxerski/Hyprland";
    };

  outputs =
    inputs@
    { self
    , pkgs
    , digga
    , nixos
    , home
    , nixos-hardware
    , nur
    , agenix
    , nvfetcher
    , deploy
    , emacs
    , musnix-flake
    , hyprland-flake
    , ...
    }:
    digga.lib.mkFlake
      {
        inherit self inputs;

        channelsConfig = {
          allowUnfreePredicate = pkg: builtins.elem (nixos.lib.getName pkg) [
            # Narice Unfree Packages
            "discord"
            "minecraft-launcher"
            "slack"
            "steam"
            "steam-original"
            "steam-runtime"
            "teams"
            "widevine"
            "yuzu-mainline"
            "yuzu-ea"
            "zoom"
          ];
        };

        channels = {
          nixos = {
            imports = [ (digga.lib.importOverlays ./overlays) ];
            overlays = [ ];
          };
          unstable = { };
          latest = { };
        };

        lib = import ./lib { lib = digga.lib // nixos.lib; };

        sharedOverlays = [
          (final: prev: {
            __dontExport = true;
            lib = prev.lib.extend (lfinal: lprev: {
              our = self.lib;
            });
          })

          nur.overlay
          agenix.overlay
          nvfetcher.overlay

          pkgs.overlay # for `srcs`
          (import ./pkgs)

          deploy.overlay
          emacs.overlay
          hyprland-flake.overlays.default
        ];

        nixos = {
          hostDefaults = {
            system = "x86_64-linux";
            channelName = "nixos";
            imports = [ (digga.lib.importExportableModules ./modules) ];
            modules = [
              { lib.our = self.lib; }
              digga.nixosModules.bootstrapIso
              digga.nixosModules.nixConfig
              home.nixosModules.home-manager
              agenix.nixosModules.age
              musnix-flake.nixosModules.musnix
              hyprland-flake.nixosModules.default
            ];
          };

          imports = [ (digga.lib.importHosts ./hosts) ];
          hosts = {
            /* set host specific properties here */
            narice-pc = { };
            astraea = {
              modules = with nixos-hardware.nixosModules; [ dell-xps-13-9310 ];
            };
          };
          importables = rec {
            profiles = digga.lib.rakeLeaves ./profiles // {
              users = digga.lib.rakeLeaves ./users;
            };
            suites = with profiles; rec {
              base = [
                core
                users.narice
                users.root
              ];
              default = [
                base
                bluetooth
                fail2ban
                fonts
                fzf
                gnome
                graphic-tablet
                hyprland
                i3
                keyboard
                lightdm
                location
                musnix
                picom
                pipewire
                printing
                qt
                redshift
                steam
                sway
                touchpad
                virtualization
                xfce
                xfce-i3
                xwayland
                zsh
              ];
              wayland = [
                base
                bluetooth
                fail2ban
                fonts
                fzf
                graphic-tablet
                hyprland
                keyboard
                musnix
                pipewire
                printing
                qt
                steam
                sway
                touchpad
                virtualization
                xwayland
                zsh
              ];
            };
          };
        };

        home = {
          imports = [ (digga.lib.importExportableModules ./users/modules) ];
          modules = [ ];
          importables = rec {
            profiles = digga.lib.rakeLeaves ./users/profiles;
            suites = with profiles; rec {
              base = [ direnv git ];
            };
          };
          # NOTE: users can be managed differently
        };

        devshell = ./shell;

        homeConfigurations = digga.lib.mkHomeConfigurations self.nixosConfigurations;

        deploy.nodes = digga.lib.mkDeployNodes self.nixosConfigurations { };
      }
  ;
}
