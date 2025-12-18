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

$env.config.color_config = {
    # Màu cho lệnh bên ngoài như: git, eza, brew... (Làm tối lại)
    shape_external: "#565f89" 
    shape_external_arg: "#414868"
    
    # Màu cho lệnh nội bộ như: ls, cd, let...
    shape_internal: "#7aa2f7" 
    
    # Màu cho các Flag như: -la, --help (Màu tím trầm)
    shape_flag: "#9d7cd8" 
    
    # Màu cho văn bản trong ngoặc kép "..."
    shape_string: "#73daca" 
    
    # Màu của các dấu phân cách |
    separator: "#24283b" 
}
source ~/.cache/starship/init.nu
