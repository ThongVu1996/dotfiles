# # aliases.nu
# # --------------------------------------------------------
#
# # 1. Reload Shell nhanh
# alias reload = exec $nu.current-exe
#
# # 2. Rebuild hệ thống (FIX: Dùng $env.HOME thay vì ~)
# # Lưu ý: Ta gọi 'sudo nix' trực tiếp, vì PATH đã được set chuẩn ở env.nu
# alias nixss = sudo nix run nix-darwin -- switch --flake $"($env.HOME)/nix-config#((scutil --get LocalHostName | str trim))"
#
# # 3. Các alias khác
# alias vi = nvim
# alias ls = ^eza
# alias lz = lazygit


# 1. Các alias đơn giản -> Thêm từ khóa 'export' vào trước
export alias reload = exec $nu.current-exe
export alias vi = ^nvim  # Dùng ^ để đảm bảo gọi lệnh ngoài
export alias lz = ^lazygit

# 2. Xử lý lệnh 'ls'
# Lưu ý: Nếu bạn đã có lệnh 'ls' tùy chỉnh (ở bài trước), 
# thì dòng dưới đây sẽ ghi đè nó. Hãy chọn 1 trong 2 thôi nhé.
export alias ls = ^eza 

# 3. Nâng cấp 'nixss' thành Function (Khuyên dùng)
# Lý do: Dùng 'def' giúp code dễ đọc hơn, biến $env.HOME và scutil được xử lý rõ ràng.
export def nixss [] {
    let hostname = (scutil --get LocalHostName | str trim)
    let flake_uri = $"($env.HOME)/nix-config#($hostname)"
    
    print $"Rebuilding system with flake: ($flake_uri)..."
    
    # Chạy lệnh
    ^sudo nix run nix-darwin -- switch --flake $flake_uri
}
