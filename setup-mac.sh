#!/bin/bash
# setup-mac.sh

echo "🛠️  Fixing Nushell paths for macOS..."

# 1. Đảm bảo thư mục cứng đầu của Apple bị xóa
rm -rf "$HOME/Library/Application Support/nushell"

# 2. Tạo đường dẫn tắt từ Library sang .config
# (Để Nushell khi khởi động sẽ bị dẫn sang file config của ta)
ln -s "$HOME/.config/nushell" "$HOME/Library/Application Support/nushell"

echo "✅ Done! Nushell is ready."
