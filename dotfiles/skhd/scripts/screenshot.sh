#!/bin/bash

# Khởi tạo file log để theo dõi
LOG_FILE="/tmp/skhd_debug.log"
echo "=== Bắt đầu chụp: $(date) | Cờ: '$1' ===" >> "$LOG_FILE"

# 1. Dọn dẹp file cũ (Dùng đường dẫn thật /private/tmp)
rm -f /private/tmp/ss_tmp.png
mkdir -p ~/Pictures/Screenshots

# 2. Chụp ảnh màn hình
screencapture $1 /private/tmp/ss_tmp.png

# 3. Chờ 1 giây
sleep 1

# 4. Copy file và ném vào clipboard
if [ -f /private/tmp/ss_tmp.png ]; then
    cp /private/tmp/ss_tmp.png ~/Pictures/Screenshots/Screenshot_$(date +%Y%m%d_%H%M%S).png
    echo "Đã lưu file thành công. Bắt đầu đẩy vào Clipboard..." >> "$LOG_FILE"
    
    # Ép osascript nhả toàn bộ lỗi (nếu có) vào file log
    osascript -e 'set the clipboard to (read (POSIX file "/private/tmp/ss_tmp.png") as «class PNGf»)' >> "$LOG_FILE" 2>&1
    
    echo "Đã chạy xong lệnh Clipboard." >> "$LOG_FILE"
else
    echo "LỖI:screencapture không tạo được file ảnh!" >> "$LOG_FILE"
fi
echo "------------------------------------" >> "$LOG_FILE"