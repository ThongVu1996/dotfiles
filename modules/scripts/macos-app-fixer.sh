#!/bin/bash
# Đảm bảo có đầy đủ PATH để chạy các lệnh hệ thống (mount, osascript, codesign)
export PATH="/run/current-system/sw/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

USER_NAME=$1
TRAMPOLINE_DIR="/Users/$USER_NAME/Applications/Home Manager Trampolines"
NIX_APPS_DIR="/Applications/Nix Apps"
LOG_FILE="/tmp/macos-app-fixer-$USER_NAME.log"

echo "--- Bắt đầu Fixer ($(date)) ---" > "$LOG_FILE"

# 1. Xử lý quyền (Codesign) cho TẤT CẢ các App
# Việc ký tên lại (re-sign) giúp fix lỗi app không chạy trên macOS mới
echo "Xử lý Codesign cho toàn bộ Apps..." >> "$LOG_FILE"
find -L "$NIX_APPS_DIR" "$TRAMPOLINE_DIR" -name "*.app" -maxdepth 2 2>/dev/null | while read -r app; do
    echo "Re-signing: $app" >> "$LOG_FILE"
    /usr/bin/codesign --force --deep --sign - "$app" >> "$LOG_FILE" 2>&1 || true
done

# 2. Sửa Icon cho Trampoline Apps
if [ -d "$TRAMPOLINE_DIR" ]; then
    for app in "$TRAMPOLINE_DIR"/*.app; do
        [ -e "$app" ] || continue
        appname=$(basename "$app" .app)
        echo "Sửa icon cho: $appname" >> "$LOG_FILE"
        
        # Tìm app gốc trong Nix Apps hoặc profiles
        nixapp=$(find -L "$NIX_APPS_DIR" "/etc/profiles/per-user/$USER_NAME/Applications" -maxdepth 2 -name "$appname.app" 2>/dev/null | head -1)
        
        icns=""
        if [ -n "$nixapp" ]; then
            icns=$(find -L "$nixapp/Contents/Resources" -maxdepth 1 -name "*.icns" 2>/dev/null | head -1)
        fi

        # Nếu không tìm thấy app gốc, thử tìm icon ngay trong bản thân Trampoline
        if [ -z "$icns" ]; then
            icns=$(find -L "$app/Contents/Resources" -maxdepth 1 -name "*.icns" 2>/dev/null | head -1)
        fi
        
        if [ -n "$icns" ]; then
            echo "Dán icon cho $appname từ $icns" >> "$LOG_FILE"
            /run/current-system/sw/bin/fileicon set "$app" "$icns" >> "$LOG_FILE" 2>&1 || true
        else
            echo "Không tìm thấy icon cho $appname" >> "$LOG_FILE"
        fi
    done
fi

# 3. Phá bỏ Cache icon - Ép macOS cập nhật
echo "Refreshing LaunchServices cache..." >> "$LOG_FILE"
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f "$TRAMPOLINE_DIR"/*.app

# Touch để Finder chú ý
/usr/bin/touch "$TRAMPOLINE_DIR"/*.app

echo "--- Hoàn thành ---" >> "$LOG_FILE"
/usr/bin/killall Finder Dock || true
