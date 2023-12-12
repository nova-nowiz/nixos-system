TERMINAL="alacritty"
EDITOR="emacsclient -cn"
VISUAL="emacsclient -cn"
NIX_BUILD_SHELL="/usr/bin/env zsh"
PATH="$PATH:$HOME/.config/emacs/bin:$HOME/.local/bin"

FZF_BASE_COMMAND="fd --color=always --hidden --exclude .git"
FZF_BASE_OPTS="--ansi --preview 'bat --style=changes --color=always --line-range :500 {}'"

FZF_COMPLETION_OPTS="${FZF_BASE_OPTS}"

FZF_DEFAULT_COMMAND="${FZF_BASE_COMMAND} --type f"
FZF_DEFAULT_OPTS="${FZF_BASE_OPTS}"

FZF_CTRL_T_COMMAND="${FZF_BASE_COMMAND} --type f"
FZF_CTRL_T_OPTS="${FZF_BASE_OPTS}"

FZF_CTRL_R_OPTS="--ansi --preview ''"

FZF_ALT_C_COMMAND="${FZF_BASE_COMMAND} --type d"
FZF_ALT_C_OPTS="--ansi --preview 'exa -1 --color=always {}'"
