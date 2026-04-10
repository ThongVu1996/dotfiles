function tsn --description 'Tạo hoặc Switch sang một tmux session'
    # 1. Kiểm tra argument
    if test (count $argv) -eq 0
        echo "Lỗi: Bạn cần cung cấp tên cho session."
        echo "Cú pháp: ts <ten_session>"
        return 1
    end

    set -l session_name $argv[1]

    # Kiểm tra session đã tồn tại hay chưa
    set -l session_exists (tmux has-session -t "$session_name" 2>/dev/null; echo $status)
    
    # 2. Kiểm tra xem có đang ở trong Tmux không (dùng $TMUX)
    if set -q TMUX
        # Đang ở trong Tmux: Chỉ được dùng switch-client (hoặc new-session khi cần tạo mới)
        
        if test $session_exists -eq 0
            # Session đã tồn tại, chuyển đổi session
            tmux switch-client -t "$session_name"
        else
            # Session chưa tồn tại, tạo session mới nhưng phải detach khỏi client hiện tại
            # và sau đó switch-client vào session mới.
            # (Cách an toàn hơn là dùng new-session -d sau đó switch-client)
            tmux new-session -d -s "$session_name"
            tmux switch-client -t "$session_name"
        end

    else
        # Đang ở ngoài Tmux: Dùng new-session -A để tạo hoặc attach
        # Cách này an toàn và gọn gàng khi ở ngoài
        tmux new-session -A -s "$session_name"
    end
end
