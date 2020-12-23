{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "/unstable";
    };
  };

  outputs = inputs:
  let
    pkgs = import inputs.unstable {
      system = "x86_64-linux";
      config = {
        allowUnfreePredicate = pkg: builtins.elem (inputs.unstable.lib.getName pkg) [
      # System Unfree Packages
          #"nvidia-x11"
          #"nvidia-settings"
          #"nvidia-persistenced"
      "teamviewer"

      # Users Unfree Packages
          "discord"
          "steam"
          "steam-original"
          "steam-runtime"
          "minecraft-launcher"
          "teams"
          "idea-ultimate"
          "vscode"
        ];
      };
    };
  in
  {
    nixosConfigurations = {
      narice-pc = inputs.unstable.lib.nixosSystem {

        system = "x86_64-linux";

        specialArgs = {
          inherit pkgs;
        };

        modules = [ 
          ./base.nix

          inputs.home-manager.nixosModules.home-manager

          ({config, pkgs, lib, ...}:{

            networking = {
              hostName = "narice-pc";
              interfaces.eno1.useDHCP = true;
            };

            system.configurationRevision =
              if inputs.self ? rev
              then inputs.self.rev
              else throw "Refusing to build from a dirty Git tree";

            nix.registry.nixpkgs.flake = inputs.unstable;

            home-manager = {
              useGlobalPkgs = true;
              users.narice = import home/narice.nix;
              users.monasbook = import home/monasbook.nix;
            };
          })
        ];
      };

      narice-hp = inputs.unstable.lib.nixosSystem {

        system = "x86_64-linux";

        specialArgs = {
          inherit pkgs;
        };

        modules = [ 
          ./base.nix

          inputs.home-manager.nixosModules.home-manager

          ({config, pkgs, lib, ...}:{

            networking = {
              hostName = "narice-hp";
              #interfaces.eno1.useDHCP = true;
              wireless.enable = true;
            };

            system.configurationRevision =
              if inputs.self ? rev
              then inputs.self.rev
              else throw "Refusing to build from a dirty Git tree";

            nix.registry.nixpkgs.flake = inputs.unstable;

            home-manager = {
              useGlobalPkgs = true;
              users.narice = import home/narice.nix;
            };
          })
        ];
      };
    };
  };
}
