{ self, inputs, ... }:
{
  exportedModules = with inputs; [ ];
  modules = [
    ./devos.nix
  ];
}

