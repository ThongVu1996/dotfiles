#!/bin/bash

cpu_percent=(
  # --- Cài đặt chung ---
  width=40                  # Độ rộng cố định để chứa đủ 2 dòng
  align=right              # Căn giữa nội dung
  update_freq=2
  drawing=on              # Mặc định ẩn
  script="$PLUGIN_DIR/cpu.sh"

  # --- Cấu hình phần Chữ "CPU" (Dùng slot Icon) ---
  icon="CPU"                # Đặt text tĩnh là CPU
  icon.drawing=on
  icon.font="$FONT:Bold:9"  # Font nhỏ, đậm (cỡ 9)
  icon.y_offset=10
  icon.padding_right=-20         # Đẩy chữ CPU lên trên
  icon.color=0xffffffff     # Màu trắng (hoặc chỉnh theo theme của bạn)

  # --- Cấu hình phần Số % (Dùng slot Label) ---
  label.font="$FONT:Heavy:12" # Font to, rất đậm (cỡ 15) cho số %
  label.y_offset=-4           # Đẩy số xuống dưới
  label.padding_left=0        # Xóa khoảng cách mặc định để căn thẳng hàng hơn
  label.color=0xffffffff      # Màu trắng
)

sketchybar --add item cpu.percent right          \
           --set cpu.percent "${cpu_percent[@]}"