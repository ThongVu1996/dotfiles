function twr --description 'Đổi tên Window hiện tại của Tmux.'
    # 1. KIỂM TRA THAM SỐ: Đảm bảo người dùng nhập tên mới
    if test (count $argv) -eq 0
        echo (set_color red) "Lỗi:" (set_color normal) "Bạn cần cung cấp tên mới cho Window."
        echo "Cú pháp: twr <ten_moi>"
        return 1
    end

    set new_window_name $argv[1]

    # 2. KIỂM TRA MÔI TRƯỜNG: Xác định trạng thái của Tmux

    # Kiểm tra biến môi trường $TMUX: PHẢI đang ở TRONG session mới rename được
    if set -q TMUX
        echo (set_color green) "Đang trong Session:" (set_color normal) "Đổi tên Window hiện tại thành '$new_window_name'."
        tmux rename-window $new_window_name
    else
        # Nếu KHÔNG ở trong Session, lệnh rename-window sẽ không hoạt động
        echo (set_color red) "Lỗi:" (set_color normal) "Lệnh đổi tên Window (trw) chỉ có thể chạy từ BÊN TRONG Tmux Session."
        echo "Vui lòng đính kèm vào Session trước (tmux attach) hoặc đổi tên thủ công (tmux rename-window) nếu bạn biết id."
        return 1
    end
end
