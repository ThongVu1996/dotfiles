function ls --wraps eza
    # Kiểm tra: Nếu chỉ có đúng 1 tham số VÀ tham số đó là Số (ví dụ: 1, 2, 3...)
    if test (count $argv) -eq 1; and string match -qr '^[0-9]+$' -- "$argv[1]"
        eza --tree --level=$argv[1]
    else
        # Các trường hợp còn lại (ls, ls -la, ls /tmp...) chạy eza bình thường
        eza $argv
    end
end
