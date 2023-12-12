{ self, config, lib, pkgs, options, ... }:
let inherit (lib) fileContents;
in
{
  virtualisation = {
    kvmgt.enable = true;
    libvirtd.enable = true;
    docker.enable = true;
  } //
  (lib.optionalAttrs (builtins.hasAttr "qemu" options.virtualisation) {
    memorySize = 16 * 1024;
    msize = 24 * 1024;
    cores = 8;
    resolution = {
      x = 1080;
      y = 720;
    };
    qemu = {
      # TODO: can we make it so the resolution is not crap?
      # -g doesn't work sdl doesn't work gl=on is necessary
      # maybe it's a driver issue?
      # nope, qxl doesn't work (resolution problem)
      # qxl+spice is really bad
      # virtio+axrandr for managing res is really good but not at startup
      # screenfetch
      options = [
        "-vga none"
        "-device virtio-vga-gl"
        "-display gtk,gl=on"
        "-cpu host"
        "-enable-kvm"
        "-audiodev pa,id=usb,out.mixing-engine=off"
        "-device usb-audio,audiodev=usb,multi=on"
      ];
    };
    # useNixStoreImage = true;
  });
}
