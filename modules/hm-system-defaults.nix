{ config, lib, ... }: {
  home-manager = {
    useUserPackages = lib.mkForce false;
    sharedModules = [
      {
        home.sessionVariables = {
          inherit (config.environment.sessionVariables) NIX_PATH;
        };
        xdg.configFile."nix/registry.json".text =
          config.environment.etc."nix/registry.json".text;
      }
    ];
  };
}
