{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ardour
    x42-plugins
    tap-plugins
    lsp-plugins
    distrho
    zam-plugins
    calf
    infamousPlugins
    gxplugins-lv2
    dragonfly-reverb
  ];
}
