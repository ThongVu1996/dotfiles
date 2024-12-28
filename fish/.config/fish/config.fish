if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Config starship
set -U fish_greeting ""
starship init fish | source
set -Ux STARSHIP_CONFIG ~/.config/starship/starship.toml

# bat 
alias bat='batcat'

# fzf
fzf --fish | source
alias f=fzf
# preview with bat
alias fp='fzf --preview="bat --color=always {}"'
# open neovim with select file by tab
alias fv='nvim $(fzf -m --preview="bat --color=always {}")'
# Reload Fish Shell configuration
function ss
    source ~/.config/fish/config.fish
    echo "Reloaded Fish Shell!"
end
#Reload tmux
function tmux-ss
    tmux source-file ~/.tmux.conf
    echo "Reloaded Tmux"
end

set -x PATH ~/.local/bin $PATH
set -U fish_user_paths /home/linuxbrew/.linuxbrew/bin $fish_user_paths
eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)

set -U fish_user_paths $HOME/.local/share/nvim/mason/bin $fish_user_paths

# fastafetch
export PATH="/usr/local/bin:$PATH"

