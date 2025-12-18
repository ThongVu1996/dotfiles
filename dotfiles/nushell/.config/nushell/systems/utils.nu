# functions/utils.nu

# Custom ls commands (wrapper cho eza)
# Logic: Nếu tham số là int -> eza --tree --level, ngược lại chạy eza thường
# Thêm --wrapped để chấp nhận các cờ như -l, -a, -la...
# Dùng ...args để gom tất cả tham số vào một danh sách
export def --env --wrapped l [...args] {
    # Kiểm tra xem có phải trường hợp đặc biệt (chỉ có 1 tham số là số) không
    # Điều kiện: Danh sách args có độ dài là 1 VÀ phần tử đầu tiên là int
    let is_tree_mode = (($args | length) == 1) and (($args | first | describe) == 'int')

    if $is_tree_mode {
        # Trường hợp: ls 2 -> Tree view level 2
        ^eza --tree --level ($args | first)
    } else {
        # Các trường hợp còn lại: ls, ls -la, ls folder...
        # Dùng ...$args để "bung" (splat) danh sách ra thành các tham số rời cho eza
        ^eza ...$args
    }
}
# Reload config
export def --env ss [] {
    exec nu
}

# Navigation Shortcuts (Cd + Echo)
export def --env fcf [] { cd ~/nix-config/dotfiles/fish/.config/fish; print "🐟 You can configure Fish" }
export def --env vcf [] { cd ~/nix-config/dotfiles/nvim/.config/nvim; print "📝 You can configure Neovim" }
export def --env tcf [] { cd ~/nix-config/dotfiles/tmux; print "🪟 You can configure Tmux" }
export def --env scf [] { cd ~/nix-config/dotfiles/starship/; print "🚀 You can configure Starship" }
export def --env wcf [] { cd ~/nix-config/dotfiles/wezterm/.config/wezterm; print "Wezterm config" }
export def --env acf [] { cd ~/nix-config/dotfiles/aerospace/.config/aerospace; print "Aerospace config" }
export def --env lzcf [] { cd ~/nix-config/dotfiles/lazygit/.config/lazygit; print "Lazygit config" }
export def --env ncf [] { cd ~/nix-config; print "❄️ Nix config" }
export def --env pcf [] { cd ~/Project/; print "📂 Project folder" }
export def --env nucf [] {
    cd ~/nix-config/dotfiles/nushell/.config/nushell
    print "🚀 You can configure Nushell"
}
