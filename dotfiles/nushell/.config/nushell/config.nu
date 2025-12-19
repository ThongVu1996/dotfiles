# config.nu
# --------------------------------------------------------

# 1. GIAO DIỆN & TRẢI NGHIỆM
$env.config.show_banner = false       # Tắt banner welcome
$env.config.buffer_editor = "nvim"    # Dùng nvim khi nhấn Ctrl+X E
$env.config.table.mode = "rounded"    # Viền bảng bo tròn đẹp hơn
$env.config.ls.use_ls_colors = true   # Màu sắc cho lệnh ls

# 2. KEYBINDINGS (Phím tắt hữu ích)
$env.config.keybindings = ($env.config.keybindings | append [
    # Ctrl + R: Reload lại config nhanh chóng
    {
        name: reload_config
        modifier: control
        keycode: char_r
        mode: [emacs, vi_normal, vi_insert]
        event: { send: executehostcommand, cmd: "exec $nu.current-exe" }
    }
    # Ctrl + L: Xóa màn hình (giống bash/zsh)
    {
        name: clear_screen
        modifier: control
        keycode: char_l
        mode: [emacs, vi_normal, vi_insert]
        event: { send: ClearScreen }
    }
])

# 3. Import các function, alias
use systems *
use utils *
# 4. HOOKS (Tự động load môi trường)
$env.config.hooks = {
    env_change: {
        PWD: [
            { |before, after|
                # Hook cho direnv (cực mạnh khi dùng với Nix Shell)
                if (not (which direnv | is-empty)) {
                    direnv export json | from json | default {} | load-env
                }
            }
        ]
    }
}

# 5. LOAD STARSHIP
source ~/.cache/starship/init.nu
