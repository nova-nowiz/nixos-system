{ self, config, lib, pkgs, options, ... }:
let inherit (lib) fileContents;
in
{
  services = {
    picom = {
      enable = true;
      backend = "glx";
      fade = true;
      fadeDelta = 5;
      vSync = true;
      shadow = false;
      shadowOffsets = [ 0 0 ];
      opacityRules = [
        # basically I'll have to put applications that are not references, but input things in there
        "80:class_g = 'Alacritty' && !_NET_WM_STATE@:32a"
        "80:class_g = 'Emacs' && !_NET_WM_STATE@:32a && !focused"
        "95:class_g = 'Emacs' && !_NET_WM_STATE@:32a && focused"
        "0:_NET_WM_STATE@:32a *= '_NET_WM_STATE_HIDDEN'"
      ];
      settings = {
        experimental-backends = true;
        corner-radius = 10;
        rounded-corners-exclude = [
          #"class_g = 'i3-frame'"
          "class_g = 'plasmashell'"
        ];
        round-borders = 1;
        frame-opacity = 0.7;
        blur = {
          method = "kawase";
          strength = 3;
          background = false;
          background-frame = false;
          background-fixed = false;
          kern = "3x3box";
        };
        blur-background-exclude = [ "class_g = 'Peek'" ];
        mark-wmwin-focused = true;
        detect-rounded-corners = true;
        detect-client-opacity = true;
        detect-transient = true;
        detect-client-leader = true;
        log-level = "info";
      };
    };
  };
}
