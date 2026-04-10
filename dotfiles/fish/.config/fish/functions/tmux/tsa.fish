function tsa --description 'Attach hoặc Switch sang một tmux session (Cách 2)'
    if test (count $argv) -eq 0
        echo "Lỗi: Vui lòng cung cấp tên tmux session để attach/switch."
        echo "Cú pháp: tsa <tên_session>"
        return 1
    end

    set -l session_name $argv[1]

    if not tmux has-session -t "$session_name" 2>/dev/null
        echo "Lỗi: Session tmux '$session_name' không tồn tại."
        return 1
    end

    # Kiểm tra xem có đang ở trong Tmux không
    if set -q TMUX
        # Đang ở trong Tmux: Dùng switch-client.
        env -u TMUX tmux switch-client -t "$session_name"
    else
        # Đang ở ngoài Tmux: Dùng attach-session.
        tmux attach-session -t "$session_name"
    end
end
