# TODO: transform this pkgs into an option maybe?
{ stdenv, lib, srcs, ... }:
let
  inherit (srcs)
    zsh-fzf-tab
    zsh-autopair
    zsh-nix-shell
    zsh-completions
    zsh-you-should-use
    zsh-powerlevel10k;
in
stdenv.mkDerivation {

  name = "ohMyZshCustom";

  # put the plugins that have the following criteria here:
  # - there is at least one *.plugin.zsh file
  # - the first *.plugin.zsh file in alphabetical order is the name of the plugin
  # e.g:
  # autopair has autopair.plugin.zsh and zsh-autopair.plugin.zsh
  # alphabetically, autopair.plugin.zsh will be before zsh-autopair.plugin.zsh
  # autopair is the name of the plugin so this is totally what we want.
  # so what we will have as a result is this in our custom directory:
  # custom/plugins
  #   autopair
  #     ...
  #     autopair.plugin.zsh <- this will be the one used!
  #     ...
  #     zsh-autopair.plugin.zsh <- this one does not disapear but is useless basically
  #     ...
  #
  # so to use it, you would put in the ohMyZsh.plugins list "autopair".
  #
  # if zsh-autopair.plugin.zsh was the first or only one we would have this instead:
  # custom/plugins
  #   zsh-autopair
  #     ...
  #     zsh-autopair.plugin.zsh <- this is now the one that will be used ;)
  #     ...
  #
  # and so in the plugins list, we would put "zsh-autopair"
  #
  srcsPlugins = [
    zsh-fzf-tab
    zsh-autopair
    zsh-nix-shell
    zsh-completions
    zsh-you-should-use
  ];

  # put the themes that have the following criteria here:
  # - there is at least one *.zsh-theme file
  # - the first *.zsh-theme file in alphabetical order is the name of the theme
  # e.g:
  # a very good example is powerlevel10k:
  # there are two files: powerlevel10k.zsh-theme and powerlevel9k.zsh-theme
  # here, don't be fooled by the numbers,
  # 1 comes before 9 so powerlevel10k.zsh-theme will be the name of the theme, perfect!
  # here is the result:
  # custom/themes
  #   powerlevel10k
  #     ...
  #     powerlevel10k.zsh-theme <- this is most probably the file you will use
  #     ...
  #     powerlevel9k.zsh-theme <- but this can also be used!
  #     ...
  #
  # here is how you would use the theme:
  # ohMyZsh.theme = "powerlevel10k/powerlevel10k"
  # or in this case, you can also use the powerlevel9 file:
  # ohMyZsh.theme = "powerlevel10k/powerlevel9k"
  #
  srcsThemes = [
    zsh-powerlevel10k
  ];

  dontUnpack = true;

  # if you want to add a plugin or theme that doesn't respect the rules above, you can
  # copy it manually in this install phase.
  # the plugin source path will be $<plugin name as defined in the inherit above>.
  #
  installPhase = ''
    # PLUGINS
    plugins="$out/plugins"
    mkdir -p "$plugins"

    # this installs all plugins that are in the srcsPlugins automatically
    for src in $srcsPlugins; do
      pluginFile=$(find $src/*.plugin.zsh | head -n 1)
      pluginFileBasepath=''${pluginFile##*/}
      pluginName=''${pluginFileBasepath%.plugin.zsh}
      cp -r "$src" "$plugins/$pluginName"
    done

    #THEMES
    themes="$out/themes"
    mkdir -p "$themes"

    # this installs all themes that are in the srcsThemes automatically
    for src in "$srcsThemes"; do
      themeFile=$(find $src/*.zsh-theme | head -n 1)
      themeFileBasepath=''${themeFile##*/}
      themeName=''${themeFileBasepath%.zsh-theme}
      cp -r "$src" "$themes/$themeName"
    done
  '';
}
