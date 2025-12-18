# functions/fzf.nu

# Alias f
export alias f = fzf

# Preview with bat
export alias fp = fzf --preview="bat --color=always {}"

# Open neovim with select file (fv)
export def --env fv [] {
    let file = (fzf -m --preview="bat --color=always {}" | str trim)
    if ($file | is-not-empty) {
        nvim $file
    }
}
