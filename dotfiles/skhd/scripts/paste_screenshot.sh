#!/bin/bash

# 1. Dọn dẹp file cũ hơn 24h (1440 phút) trong /private/tmp
find /private/tmp -maxdepth 1 -name "ss_*.png" -mmin +1440 -delete 2>/dev/null

# 2. Tạo đường dẫn mới
NEW_PATH="/private/tmp/ss_$(date +%s).png"

# 3. Kiểm tra xem file ss_tmp.png có tồn tại không
if [ -f /private/tmp/ss_tmp.png ]; then
    # Copy sang file mới để cất
    cp /private/tmp/ss_tmp.png "$NEW_PATH"
    
    # Dùng osascript để gõ trực tiếp đường dẫn kèm dấu ngoặc kép và dấu cách
    osascript -e "tell application \"System Events\" to keystroke \"\\\"$NEW_PATH\\\" \""
else
    osascript -e 'display notification "Không tìm thấy ảnh chụp tạm (ss_tmp.png)" with title "Lỗi Dán Ảnh"'
fi
