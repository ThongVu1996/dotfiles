function twn --description 'Tạo một Tmux Window mới với tên chỉ định.'
    # 1. KIỂM TRA THAM SỐ: Đảm bảo người dùng nhập tên Window
    if test (count $argv) -eq 0
        echo (set_color red) "Lỗi:" (set_color normal) "Bạn cần cung cấp tên cho Window mới."
        echo "Cú pháp: twn <ten_window>"
        return 1
    end

    set window_name $argv[1]

    # 2. KIỂM TRA MÔI TRƯỜNG: Xác định trạng thái của Tmux

    # Kiểm tra biến môi trường $TMUX: Nếu đang ở TRONG session
    if set -q TMUX
        echo (set_color green) "Đang trong Session:" (set_color normal) "Tạo Window '$window_name' trong Session hiện tại."
        tmux new-window -n $window_name

    # Kiểm tra nếu KHÔNG ở trong Session, nhưng có Tmux Server đang chạy ngầm
    else if tmux has-session >/dev/null 2>&1
        echo (set_color yellow) "Cảnh báo:" (set_color normal) "Tmux Server đang chạy ngầm, nhưng bạn chưa đính kèm."
        echo "Tạo Window '$window_name' trong Session MẶC ĐỊNH (hoặc Session gần nhất) và đính kèm vào đó."
        # Lệnh này tạo window và chuyển đến nó, hoặc bạn có thể dùng 'tmux new-window -d' để tạo ngầm.
        tmux attach -c (tmux new-window -d -n $window_name -P -F "#{session_name}")

    # Không có Session nào đang chạy
    else
        echo (set_color red) "Lỗi:" (set_color normal) "Không có Tmux Session nào đang hoạt động."
        echo "Vui lòng tạo Session mới trước bằng lệnh 'ts <ten_session>'."
        return 1
    end
end
