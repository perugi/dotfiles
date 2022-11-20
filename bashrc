# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi

#Alias definitions.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

unset rc

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# Enable key bindings for dash, CTRL-T for files, CTRL-R for commands
# ALT-C to cd into directory
if [ -x "$(command -v fzf)"  ]; then
    source /usr/share/fzf/shell/key-bindings.bash
fi

# Activate vim keybindings.
set -o vi

# Make vim the default editor.
export EDITOR=vim

# Source the custom functions
source ~/.scripts/functions

# Initialize starship
eval "$(starship init bash)"

# Start tmux when terminal is opened.
if [ -x "$(command -v tmux)" ] && [ -n "${DISPLAY}" ] && [ -z "${TMUX}" ]; then
    tmux attach || tmux >/dev/null 2>&1
fi

