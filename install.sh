#!/bin/bash
set -e

# --- MÀU SẮC ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}=== BẮT ĐẦU CÀI ĐẶT (SSL SYMLINK TRICK) ===${NC}"

# 0. CHECK FILE FLAKE
if [ ! -f "flake.nix" ]; then
    echo -e "${RED}[Lỗi] Không tìm thấy 'flake.nix'! Hãy cd vào thư mục repo.${NC}"
    exit 1
fi

# 1. DỌN DẸP BACKUP CŨ
echo -e "\n${BLUE}[1] Kiểm tra file backup hệ thống...${NC}"
for file in bashrc zshrc bash.bashrc synthetic.conf; do
    if [ -f "/etc/${file}.backup-before-nix" ]; then
        sudo mv "/etc/${file}.backup-before-nix" "/etc/${file}"
    fi
done

# 2. CÀI ĐẶT NIX (DÙNG DETERMINATE SYSTEMS)
if ! command -v nix &> /dev/null; then
    echo -e "\n${BLUE}[2] Đang cài đặt Nix...${NC}"
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
    if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    fi
else
    echo -e "\n${BLUE}[2] Nix đã có sẵn.${NC}"
fi

# 3. KỸ THUẬT "MAGIC SYMLINK" CHO SSL (QUAN TRỌNG NHẤT)
# Tạo đường dẫn Linux (/etc/ssl/certs...) trỏ về chứng chỉ macOS (/etc/ssl/cert.pem)
# Điều này giúp Nix có mạng ngay cả khi ta xóa file config của nó.
echo -e "\n${BLUE}[3] Tạo đường dẫn SSL giả lập Linux...${NC}"

if [ ! -d "/etc/ssl/certs" ]; then
    echo "Tạo thư mục /etc/ssl/certs..."
    sudo mkdir -p /etc/ssl/certs
fi

echo "Link chứng chỉ macOS vào vị trí Nix mong muốn..."
# Force link (-sf) để đảm bảo nó trỏ đúng
sudo ln -sf /etc/ssl/cert.pem /etc/ssl/certs/ca-certificates.crt
export NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt

# 4. GIẢI QUYẾT XUNG ĐỘT FILE CONFIG
echo -e "\n${BLUE}[4] Dọn đường cho nix-darwin...${NC}"

# Bây giờ ta có thể xóa file config mà không sợ mất mạng
if [ -f "/etc/nix/nix.conf" ] && [ ! -L "/etc/nix/nix.conf" ]; then
    echo "${YELLOW}Di chuyển /etc/nix/nix.conf sang backup...${NC}"
    sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.before-nix-darwin
fi

# Đảm bảo thư mục tồn tại
if [ ! -d "/etc/nix" ]; then sudo mkdir -p /etc/nix; fi

# 5. BUILD HỆ THỐNG
echo -e "\n${BLUE}[5] Build & Activate...${NC}"
echo "${YELLOW}Nhập mật khẩu sudo để kích hoạt hệ thống...${NC}"

# Chạy lệnh (Đã có mạng nhờ bước 3, không bị lỗi config nhờ bước 4)
nix run --extra-experimental-features 'nix-command flakes' nix-darwin -- switch --flake . --impure

echo -e "\n${GREEN}=== CÀI ĐẶT HOÀN TẤT! ===${NC}"
echo "Vui lòng tắt Terminal và mở lại."
