#!/bin/bash
set -e # Dừng ngay lập tức nếu có bất kỳ lỗi nào

# --- CẤU HÌNH MÀU SẮC ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}=== BẮT ĐẦU CÀI ĐẶT (ULTIMATE VERSION) ===${NC}"

# --- BƯỚC 0: KIỂM TRA FILE FLAKE ---
if [ ! -f "flake.nix" ]; then
    echo -e "${RED}[Lỗi] Không tìm thấy 'flake.nix'!${NC}"
    echo "Hãy chắc chắn bạn đang đứng trong thư mục repo (vd: ~/nix-config)."
    exit 1
fi

# --- BƯỚC 1: DỌN DẸP BACKUP CŨ (TRÁNH LỖI INSTALLER) ---
echo -e "\n${BLUE}[1] Kiểm tra file backup hệ thống...${NC}"
# Nếu tồn tại file .backup-before-nix, khôi phục nó về file gốc
# để trình cài đặt mới có thể backup lại từ đầu mà không bị lỗi "file exists".
for file in bashrc zshrc bash.bashrc synthetic.conf; do
    if [ -f "/etc/${file}.backup-before-nix" ]; then
        echo "Khôi phục backup tồn đọng: /etc/${file}"
        sudo mv "/etc/${file}.backup-before-nix" "/etc/${file}"
    fi
done

# --- BƯỚC 2: CÀI ĐẶT NIX (DETERMINATE SYSTEMS) ---
if ! command -v nix &> /dev/null; then
    echo -e "\n${BLUE}[2] Đang cài đặt Nix...${NC}"
    # Sử dụng bộ cài Determinate Systems (Ổn định hơn bản gốc)
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
    
    # Nạp môi trường Nix ngay lập tức
    if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    fi
    echo -e "${GREEN}Nix đã được cài đặt!${NC}"
else
    echo -e "\n${BLUE}[2] Nix đã có sẵn. Bỏ qua.${NC}"
fi

# --- BƯỚC 3: FIX LỖI SSL (KỸ THUẬT SYMLINK) ---
echo -e "\n${BLUE}[3] Fix lỗi SSL Certificate (Magic Link)...${NC}"
# Tạo đường dẫn ảo để Nix tìm thấy chứng chỉ macOS tại nơi nó mong muốn (giống Linux)
if [ ! -d "/etc/ssl/certs" ]; then
    sudo mkdir -p /etc/ssl/certs
fi

# Link chứng chỉ macOS (/etc/ssl/cert.pem) vào vị trí Nix tìm kiếm
sudo ln -sf /etc/ssl/cert.pem /etc/ssl/certs/ca-certificates.crt

# Set biến môi trường để chắc chắn
export NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
echo "Đã cấu hình SSL thành công."

# --- BƯỚC 4: DỌN ĐƯỜNG CHO NIX-DARWIN ---
echo -e "\n${BLUE}[4] Chuẩn bị file cấu hình...${NC}"

# Nix-darwin cần quản lý file /etc/nix/nix.conf.
# Nếu file này đang tồn tại (do bộ cài tạo ra), nix-darwin sẽ báo lỗi.
# Ta đổi tên nó đi để "nhường đường".
if [ -f "/etc/nix/nix.conf" ] && [ ! -L "/etc/nix/nix.conf" ]; then
    echo "${YELLOW}Di chuyển /etc/nix/nix.conf sang backup để tránh xung đột...${NC}"
    sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.backup-before-build
fi

# --- BƯỚC 5: BUILD & ACTIVATE ---
echo -e "\n${BLUE}[5] Build hệ thống...${NC}"
echo "${YELLOW}Lưu ý: Bạn có thể cần nhập mật khẩu sudo.${NC}"

# Cho phép cài gói unfree (vscode, chrome...)
export NIXPKGS_ALLOW_UNFREE=1

# Chạy lệnh cài đặt
# --impure: Để đọc biến môi trường NIXPKGS_ALLOW_UNFREE
sudo -E nix run --extra-experimental-features 'nix-command flakes' \
    nix-darwin -- switch --flake . --impure

echo -e "\n${GREEN}===============================================${NC}"
echo -e "${GREEN}   CÀI ĐẶT HOÀN TẤT! HỆ THỐNG ĐÃ SẴN SÀNG.   ${NC}"
echo -e "${GREEN}===============================================${NC}"
echo "Vui lòng tắt Terminal và mở lại để Fish Shell được kích hoạt."
