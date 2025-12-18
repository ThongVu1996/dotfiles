# config.nu
# --------------------------------------------------------

# 1. Import các function, alias
use systems *
use utils *
# 2. SETTINGS: Cấu hình chung
$env.config.show_banner = false
$env.config.buffer_editor = "nvim"
$env.config.table.mode = "rounded" # Hiển thị bảng đẹp hơn (bo tròn)

# 3. KEYBINDINGS: Phím tắt hệ thống
$env.config.keybindings = ($env.config.keybindings | append [
    # Ctrl + R: Reload nhanh toàn bộ config (thay vì gõ lệnh)
    {
        name: reload_config
        modifier: control
        keycode: char_r
        mode: [emacs, vi_normal, vi_insert]
        event: { send: executehostcommand, cmd: "exec $nu.current-exe" }
    }
])
source ~/.cache/starship/init.nu
