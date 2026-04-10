function tsr
    # Kiểm tra xem người dùng có cung cấp tên session hay không
    if test (count $argv) -eq 0
        echo "Lỗi: Bạn cần cung cấp tên mới cho session hiện tại"
        echo "Cú pháp: tsr <ten_session_moi>"
        return 1 # Trả về lỗi
    end

    # Thực thi lệnh Tmux new-session với tham số đầu tiên ($argv[1]) là tên session
    tmux rename-session $argv[1]
end
