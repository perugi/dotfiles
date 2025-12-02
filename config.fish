source ~/.config/fish/alias.fish

# Use vim as a default editor
set -gx EDITOR vim

# Use vi key bindings
set -g fish_key_bindings fish_vi_key_bindings

# If tmux is installed and not running, launch a new session
if type -q tmux
    if not test -n "$TMUX"
        tmux attach-session -t default; or tmux new-session -s default
    end
end

# Set up fzf key bindings
if type -q fzf
    if test -f /usr/share/fish/vendor_functions.d/fzf_key_bindings.fish
        source /usr/share/fish/vendor_functions.d/fzf_key_bindings.fish
        fzf_key_bindings
    else if test -f /usr/share/doc/fzf/examples/key-bindings.fish
        source /usr/share/doc/fzf/examples/key-bindings.fish
    end
end

# Initialize zoxide 
zoxide init fish | source

# Initialize Starship
starship init fish | source

# Copilot shell integration
string match -q "$TERM_PROGRAM" "vscode"
and . (code --locate-shell-integration-path fish)