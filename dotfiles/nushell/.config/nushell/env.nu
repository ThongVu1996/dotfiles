# env.nu
# --------------------------------------------------------

# 1. PATH SETUP (Quan trọng nhất cho Nix/Home Manager)
# Nushell không đọc .bashrc/.zshrc nên ta phải chỉ định thủ công nơi Nix lưu file.
let nix_paths = [
    # Ưu tiên 1: Home Manager profile (User)
    ($env.HOME | path join ".nix-profile/bin")
    
    # Ưu tiên 2: Nix default profile
    "/nix/var/nix/profiles/default/bin"
    
    # Ưu tiên 3: Nix path trên macOS (nếu có dùng nix-darwin)
    "/run/current-system/sw/bin"
    $"/etc/profiles/per-user/($env.USER)/bin"
]

# Các tool khác (Brew, Local, Cargo)
let other_paths = [
    "/opt/homebrew/bin"                           # Homebrew (Apple Silicon)
    "/usr/local/bin"                              # Homebrew (Intel)
    "/Applications/VMware Fusion.app/Contents/Library"
    ($env.HOME | path join ".local/bin")
    ($env.HOME | path join ".cargo/bin")          # Rust/Cargo
]

# 2. GHÉP PATH
# Logic: Nix Paths > Other Paths > System Paths (giữ lại path cũ để không lỗi hệ thống)
$env.PATH = ($nix_paths | append $other_paths | append $env.PATH | uniq)

# 3. SETTINGS CƠ BẢN
$env.XDG_CONFIG_HOME = ($env.HOME | path join ".config")
$env.LANG = "en_US.UTF-8"

# 4. STARSHIP INIT
# Tạo thư mục cache nếu chưa có để tránh lỗi
if not ($env.HOME | path join ".cache/starship" | path exists) {
    mkdir ($env.HOME | path join ".cache/starship")
}
starship init nu | save -f ($env.HOME | path join ".cache/starship/init.nu")

# 5. CONVERSIONS (SỬA LỖI EMPTY LIST TẠI ĐÂY)
# Sửa 'path join' thành 'str join' để fix lỗi "which" không tìm thấy lệnh
$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}
