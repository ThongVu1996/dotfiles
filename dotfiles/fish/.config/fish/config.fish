if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Setting config default for MacOS
set -gx XDG_CONFIG_HOME "$HOME/.config"

# Thêm các thư mục con vào path của function để Fish có thể tự động nạp (Autoload)
set -l function_subdirs nix tmux git utils vm
for dir in $function_subdirs
    set -p fish_function_path $XDG_CONFIG_HOME/fish/functions/$dir
end

# 1. Load môi trường của Nix-Darwin (System Packages)
if test -e /run/current-system/sw/bin
    fish_add_path /run/current-system/sw/bin
end

# 2. Load môi trường của Home Manager (Home Packages)
if test -e /etc/profiles/per-user/$USER/bin
    fish_add_path /etc/profiles/per-user/$USER/bin
else if test -e ~/.nix-profile/bin
    fish_add_path ~/.nix-profile/bin
end

# 3. Load Nix Daemon (để đảm bảo các biến môi trường khác)
if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
    source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
end

#Config paste image to markdown in nvim
set -g allow_passthrough on
set -ga update_environment TERM
set -ga update_environment TERM_PROGRAM
# Config starship
set -U fish_greeting ""
starship init fish | source
set -Ux STARSHIP_CONFIG ~/.config/starship.toml

# bat 
# alias bat='batcat'

# open nvim
alias vi='nvim'
alias ls='eza'
alias lz='lazygit'
# fzf
fzf --fish | source
alias f=fzf
# preview with bat
alias fp='fzf --preview="bat --color=always {}"'
# open neovim with select file by tab
alias fv='nvim $(fzf -m --preview="bat --color=always {}")'

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
alias acf="cd ~/nix-config/dotfiles/aerospace/.config/aerospace"
alias lzcf="cd ~/nix-config/dotfiles/lazygit/.config/lazygit"
alias ncf="cd ~/nix-config"
alias pcf="cd ~/Project/"


# Bind Ctrl + G to toggle
bind \cg toggle_side_by_side
direnv hook fish | source

set -x LANG en_US.UTF-8
set -x LC_ALL en_US.UTF-8
set -U fish_user_paths /usr/sbin $fish_user_paths

# Added by Antigravity
fish_add_path /Users/thongvu/.antigravity/antigravity/bin

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :
