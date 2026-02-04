# #!/bin/bash

network_wifi=(
  icon=􀙇
  icon.font="$FONT:Bold:14.0"
  icon.color=0xffffffff   
  label.drawing=off
  width=30               
  align=left           
  padding_right=5
  y_offset=1
  # Simple action: Open Network Preferences directly
  click_script="open -b com.apple.systempreferences /System/Library/PreferencePanes/Network.prefPane"
)

network_traffic=(
  script="$PLUGIN_DIR/network.sh"
  update_freq=2
  
  # --- 1. TẠO CÁI HỘP CỐ ĐỊNH (CONTAINER) ---
  width=50                # Độ rộng cố định (đủ chứa 100MB/s)
  align=left             # Vị trí của HỘP trên thanh bar (vẫn nằm bên phải)
  background.height=20    # (Tùy chọn) Giúp định hình khung        # Khoảng cách với icon Wifi
  
  # --- 2. DÒNG UPLOAD (Mũi tên lên) ---
  icon="↑ 0KB/s"
  icon.font="$FONT:Bold:10"
  icon.color=0xffffa6a6
  icon.y_offset=5         # Đẩy lên trên
  
  # [QUAN TRỌNG NHẤT] Kỹ thuật Neo Trái
  icon.width=0            # Set width=0 để làm điểm neo
  icon.align=left         # BẮT BUỘC: Căn trái để mũi tên dính chặt vào lề trái
  icon.padding_left=0
  icon.padding_right=0
  
  # --- 3. DÒNG DOWNLOAD (Mũi tên xuống) ---
  label="↓ 0KB/s"
  label.font="$FONT:Bold:10"
  label.color=0xff89b4fa
  label.y_offset=-5       # Đẩy xuống dưới
  
  # [QUAN TRỌNG NHẤT] Kỹ thuật Neo Trái
  label.align=left        # BẮT BUỘC: Căn trái theo dòng trên
  label.padding_left=0    # Xóa khoảng cách thừa để thẳng hàng với icon
)

# Lệnh Add (Đảo thứ tự để Wifi nằm bên trái Traffic)
sketchybar --add item network.traffic right        \
           --set network.traffic "${network_traffic[@]}" \
                                                   \
           --add item network.wifi right           \
           --set network.wifi "${network_wifi[@]}"