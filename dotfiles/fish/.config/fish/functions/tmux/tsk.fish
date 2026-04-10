function tsk --description 'Kill a specific tmux session'
    # Kiểm tra xem người dùng có cung cấp tên session không (argument đầu tiên là $argv[1])
    if test (count $argv) -eq 0
        echo "Lỗi: Vui lòng cung cấp tên tmux session để kill."
        echo "Cú pháp: tsk <tên_session>"
        return 1
    end

    set -l session_name $argv[1]

    # Thực thi lệnh tmux kill-session
    tmux kill-session -t "$session_name"

    # Kiểm tra mã thoát ($status)
    if test $status -eq 0
        echo "Đã kill session tmux: $session_name"
    else
        echo "Không thể kill session tmux: $session_name (có thể session không tồn tại)"
    end
end
