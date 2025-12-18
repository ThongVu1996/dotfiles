# systems/starship.nu

# Tạo thư mục autoload nếu chưa có
let vendor_dir = ($nu.default-config-dir | path join "vendor/autoload")
if not ($vendor_dir | path exists) {
    mkdir $vendor_dir
}

# Lưu file init của starship vào thư mục autoload
# Điều này giúp Nushell tự nạp Starship mỗi khi khởi động
^starship init nu | save -f ($vendor_dir | path join "starship.nu")

# Thiết lập đường dẫn đến file cấu hình .toml của bạn
export-env {
    $env.STARSHIP_CONFIG = ($env.HOME | path join ".config" "starship.toml")
}
