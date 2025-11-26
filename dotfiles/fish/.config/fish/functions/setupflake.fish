function setupflake
    # 1. Kiểm tra Git
    if not test -d .git
        echo "❌ Lỗi: Đây không phải là thư mục Git."
        return 1
    end

    # 2. Tạo flake.nix (nếu chưa có)
    if not test -f flake.nix
        echo "🛠 Đang tạo file flake.nix..."
        genflake
    end

    # 3. Tạo .envrc với chế độ PATH (QUAN TRỌNG: path:.)
    if not test -f .envrc
        # Dùng path:. để Nix đọc file trực tiếp, không cần git add
        echo "use flake path:." > .envrc
        echo "✅ Đã tạo .envrc (Chế độ path:.)"
    else
        # Nếu file đã tồn tại, kiểm tra xem có phải sửa lại không
        if not grep -q "path:." .envrc
             echo "⚠️ File .envrc cũ, đang update sang 'path:.'..."
             sed -i '' 's/use flake/use flake path:./' .envrc
        end
    end

    # 4. Giấu file (Vẫn giữ nguyên để không bao giờ commit nhầm)
    set files_to_hide flake.nix flake.lock .envrc .direnv
    set exclude_file ".git/info/exclude"

    for file in $files_to_hide
        if not grep -q "$file" $exclude_file
            echo "$file" >> $exclude_file
            echo "🙈 Đã thêm $file vào danh sách ẩn (.git/info/exclude)"
        end
    end

    # 5. KHÔNG CẦN git add -N nữa! (Bỏ bước này đi)
    # Vì đã dùng 'path:.', Nix tự đọc được file untracked.

    # 6. Kích hoạt Direnv
    echo "🚀 Đang kích hoạt Direnv..."
    direnv allow
end
