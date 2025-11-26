if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Config starship
set -U fish_greeting ""
starship init fish | source
set -Ux STARSHIP_CONFIG ~/.config/starship.toml

# bat 
# alias bat='batcat'

# open nvim
alias vi='nvim'
alias ls='eza'

# fzf
fzf --fish | source
alias f=fzf
# preview with bat
alias fp='fzf --preview="bat --color=always {}"'
# open neovim with select file by tab
alias fv='nvim $(fzf -m --preview="bat --color=always {}")'
# Reload Fish Shell configuration
function ss
    source ~/nix-config/dotfiles/fish/.config/fish/config.fish
    echo "Reloaded Fish Shell!"
end
#Reload tmux
function tmux-ss
    tmux source-file ~/nix-config/dotfiles/tmux/.tmux.conf
    echo "Reloaded Tmux"
end

set -x PATH ~/.local/bin $PATH
set -U fish_user_paths /home/linuxbrew/.linuxbrew/bin $fish_user_paths
set -U fish_user_paths $HOME/.local/share/nvim/mason/bin $fish_user_paths

# fastafetch
export PATH="/usr/local/bin:$PATH"

# Alias to dotfiles with echo messages
alias fcf="cd ~/nix-config/dotfiles/fish/.config/fish && echo 'You can configure Fish'"
alias vcf="cd ~/nix-config/dotfiles/nvim/.config/nvim && echo 'You can configure Neovim'"
alias tcf="cd ~/nix-config/dotfiles/tmux && echo 'You can configure Tmux'"
alias scf="cd ~/nix-config/dotfiles/starship/ && echo 'You can configure Starship'"
alias wcf="cd ~/nix-config/dotfiles/wezterm/.config/wezterm"

# Function to toggle delta side-by-side mode
function toggle_side_by_side
    # Get the current value from Git config
    set current_value (git config --global delta.side-by-side)

    # Toggle the value
    if test "$current_value" = "true"
        git config --global delta.side-by-side false
        echo "❌ Side-by-side mode disabled"
    else
        git config --global delta.side-by-side true
        echo "✅ Side-by-side mode enabled"
    end
end

# Bind Ctrl + G to toggle
bind \cg toggle_side_by_side

set -x LANG en_US.UTF-8
set -x LC_ALL en_US.UTF-8
set -U fish_user_paths /usr/sbin $fish_user_paths

