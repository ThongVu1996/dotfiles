if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Config starship
set -U fish_greeting ""
starship init fish | source
set -Ux STARSHIP_CONFIG ~/.config/starship.toml

# PATH font 
set -x FIGLET_FONT_PATH /home/linuxbrew/.linuxbrew/Cellar/figlet/2.2.5/share/figlet/
# bat 
alias bat='batcat'

# open nvim
alias vi='nvim'

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

#cargo PATH
set -gx PATH "$HOME/.cargo/bin" $PATH

function switch-php
  if test -z "$argv[1]"
    # Get the name of the calling function or alias
    set cmd (status current-command)
    echo "Usage: $cmd <php-version>"
    return 1
  end

  set php_version "php@$argv[1]"

  # Check if the specified PHP version is installed
  if not brew list --formula | grep -q "^$php_version\$"
    echo "PHP version $php_version is not installed."
    return 1
  end

  # Unlink the current PHP version (if it exists)
  if brew list --formula | grep -q "^php\$"
    brew unlink php >/dev/null 2>&1
  end

  # Unlink the specified PHP version if it's already linked
  if brew list --formula | grep -q "^$php_version\$"
    brew unlink $php_version >/dev/null 2>&1
  end

  # Link the specified PHP version
  brew link --force --overwrite $php_version >/dev/null 2>&1

  # Add the new PHP version to PATH
  set php_path "/home/linuxbrew/.linuxbrew/opt/$php_version"
  if test -d "$php_path/bin"
    fish_add_path "$php_path/bin"
  end
  if test -d "$php_path/sbin"
    fish_add_path "$php_path/sbin"
  end

  # Verify the active PHP version
  php -v
end

# Aliases for specific PHP versions
alias php74="switch-php 7.4"
alias php80="switch-php 8.0"
alias php81="switch-php 8.1"
alias php82="switch-php 8.2"

# Alias to dotfiles with echo messages
alias fcf="cd ~/dotfiles/fish/.config/fish && echo 'You can configure Fish'"
alias vcf="cd ~/dotfiles/nvim/.config/nvim && echo 'You can configure Neovim'"
alias tcf="cd ~/dotfiles/tmux && echo 'You can configure Tmux'"
alias scf="cd ~/dotfiles/starship/ && echo 'You can configure Starship'"
alias wcf="cd ~/dotfiles/wezterm/.config/wezterm"
