source ~/.config/fish/alias.fish

# Use vi key bindings
set -g fish_key_bindings fish_vi_key_bindings

# If tmux is installed and not running, launch a new session
if type -q tmux
    if not test -n "$TMUX"
        tmux attach-session -t default; or tmux new-session -s default
    end
end

# Set up fzf key bindings
fzf --fish | source

# Initialize zoxide 
zoxide init fish | source

# Initialize Starship
starship init fish | source

