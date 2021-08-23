{
  # config primarly based on divnix/devos/f88acc1 and updated to divnix/devos/079adc4
  description = "A highly structured configuration database.";

  inputs =
    {
      nixos.url = "nixpkgs/nixos-unstable";
      unstable.url = "nixpkgs/nixpkgs-unstable";
      latest.url = "nixpkgs";

      digga.url = "github:divnix/digga";
      digga.inputs.nixpkgs.follows = "nixos";
      digga.inputs.nixlib.follows = "nixos";
      digga.inputs.home-manager.follows = "home";

      bud.url = "github:divnix/bud";
      bud.inputs.nixpkgs.follows = "nixos";
      bud.inputs.devshell.follows = "digga/devshell";

      darwin.url = "github:LnL7/nix-darwin";
      darwin.inputs.nixpkgs.follows = "latest";

      home.url = "github:nix-community/home-manager";
      home.inputs.nixpkgs.follows = "nixos";

      deploy.follows = "digga/deploy";

      # TODO: research and use it
      agenix.url = "github:ryantm/agenix";
      agenix.inputs.nixpkgs.follows = "latest";

      nvfetcher.url = "github:berberman/nvfetcher";
      nvfetcher.inputs.nixpkgs.follows = "latest";
      nvfetcher.inputs.flake-compat.follows = "digga/deploy/flake-compat";
      nvfetcher.inputs.flake-utils.follows = "digga/flake-utils-plus/flake-utils";

      naersk.url = "github:nmattia/naersk";
      naersk.inputs.nixpkgs.follows = "latest";

      nixos-hardware.url = "github:nixos/nixos-hardware";

      pkgs.url = "path:./pkgs";
      pkgs.inputs.nixpkgs.follows = "nixos";

      emacs.url = "github:nix-community/emacs-overlay/4470595d93d25163609226c21e1a1dcf366de2ea";
      musnix.url = "github:musnix/musnix";

      # start ANTI CORRUPTION LAYER
      # remove after https://github.com/NixOS/nix/pull/4641
      nixpkgs.follows = "nixos";
      nixlib.follows = "digga/nixlib";
      blank.follows = "digga/blank";
      flake-utils-plus.follows = "digga/flake-utils-plus";
      flake-utils.follows = "digga/flake-utils";
      # end ANTI CORRUPTION LAYER
    };

  outputs =
    inputs@
    { self
    , pkgs
    , digga
    , bud
    , nixos
    , home
    , nixos-hardware
    , nur
    , agenix
    , nvfetcher
    , deploy
    , emacs
    , musnix
    , ...
    }:
    digga.lib.mkFlake {
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
          "yuzu-ea"
          "zoom"
        ];
      };

      channels = {
        nixos = {
          imports = [ (digga.lib.importOverlays ./overlays) ];
          overlays = [
            pkgs.overlay # for `srcs`
            digga.overlays.patchedNix
            nur.overlay
            agenix.overlay
            nvfetcher.overlay
            deploy.overlay
            emacs.overlay
            ./pkgs/default.nix
          ];
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
      ];

      nixos = {
        hostDefaults = {
          system = "x86_64-linux";
          channelName = "nixos";
          imports = [ (digga.lib.importModules ./modules) ];
          externalModules = [
            { lib.our = self.lib; }
            digga.nixosModules.bootstrapIso
            digga.nixosModules.nixConfig
            home.nixosModules.home-manager
            agenix.nixosModules.age
            bud.nixosModules.bud
            musnix.nixosModules.musnix
          ];
        };

        imports = [ (digga.lib.importHosts ./hosts) ];
        hosts = {
          /* set host specific properties here */
          narice-pc = { };
        };
        importables = rec {
          profiles = digga.lib.rakeLeaves ./profiles // {
            users = digga.lib.rakeLeaves ./users;
          };
          suites = with profiles; rec {
            base = [ core users.narice users.root ];
          };
        };
      };

      home = {
        imports = [ (digga.lib.importModules ./users/modules) ];
        externalModules = [ ];
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

      defaultTemplate = self.templates.bud;
      templates.bud.path = ./.;
      templates.bud.description = "bud template";
    }
    //
    {
      budModules = { devos = import ./bud; };
    }
  ;
}
