#!/bin/bash
set -e # Dừng ngay nếu lỗi

# --- CẤU HÌNH MÀU SẮC ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}=== BẮT ĐẦU CÀI ĐẶT (ZERO TO HERO - CONFLICT FIX) ===${NC}"

# 0. CHECK FILE FLAKE
if [ ! -f "flake.nix" ]; then
    echo -e "${RED}[Lỗi] Không tìm thấy 'flake.nix'!${NC}"
    echo "Hãy chắc chắn bạn đang chạy script trong thư mục repo (nix-config)."
    exit 1
fi

# 1. DỌN DẸP BACKUP CŨ
echo -e "\n${BLUE}[1] Kiểm tra file backup hệ thống...${NC}"
for file in bashrc zshrc bash.bashrc synthetic.conf; do
    if [ -f "/etc/${file}.backup-before-nix" ]; then
        sudo mv "/etc/${file}.backup-before-nix" "/etc/${file}"
    fi
done

# 2. CÀI ĐẶT NIX
if ! command -v nix &> /dev/null; then
    echo -e "\n${BLUE}[2] Đang cài đặt Nix...${NC}"
    sh <(curl -L https://nixos.org/nix/install) --daemon --yes
    if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    fi
fi

# 3. CẤU HÌNH NIX DAEMON (Tạm thời để fix SSL/Permissions)
echo -e "\n${BLUE}[3] Cấu hình Nix Daemon tạm thời...${NC}"
if [ ! -d "/etc/nix" ]; then sudo mkdir -p /etc/nix; fi

# Ghi file config để daemon chạy được
sudo bash -c "cat > /etc/nix/nix.conf <<EOF
build-users-group = nixbld
trusted-users = root $USER
ssl-cert-file = /etc/ssl/cert.pem
experimental-features = nix-command flakes
EOF"

# Restart daemon để nhận config
if [ -f "/Library/LaunchDaemons/org.nixos.nix-daemon.plist" ]; then
    sudo launchctl kickstart -k system/org.nixos.nix-daemon 2>/dev/null || true
    sleep 3
fi

# 4. BUILD HỆ THỐNG
echo -e "\n${BLUE}[4] Build hệ thống...${NC}"

# === FIX LỖI "Unexpected files in /etc" TẠI ĐÂY ===
# Trước khi nix-darwin chạy, ta phải dọn đường cho nó.
# Ta đổi tên file config thủ công vừa tạo ở trên, để nix-darwin tự tạo symlink mới.
if [ -f "/etc/nix/nix.conf" ] && [ ! -L "/etc/nix/nix.conf" ]; then
    echo "${YELLOW}Di chuyển /etc/nix/nix.conf sang .backup để tránh xung đột...${NC}"
    sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.before-nix-darwin
fi

export NIXPKGS_ALLOW_UNFREE=1
echo "Đang kích hoạt..."

# Chạy lệnh switch
sudo -E nix run --extra-experimental-features 'nix-command flakes' nix-darwin -- switch --flake . --impure

echo -e "\n${GREEN}=== CÀI ĐẶT HOÀN TẤT! ===${NC}"
echo "Hãy tắt Terminal và mở lại."
