{ self, config, lib, pkgs, options, ... }:
let inherit (lib) fileContents;
in
{
  services = {
    udev.packages = [
      (pkgs.writeTextDir "/etc/udev/rules.d/85-sunshine.rules"
        ''
          KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"
        '')
    ];
  };
}
