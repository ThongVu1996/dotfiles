#!/bin/bash

# --- CẤU HÌNH MÀU SẮC ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${RED}!!! CẢNH BÁO: CHẾ ĐỘ HỦY DIỆT (NUKE) !!!${NC}"
echo "Script này sẽ đưa máy Mac về trạng thái nguyên thủy:"
echo "1. Xóa ổ đĩa /nix và toàn bộ packages."
echo "2. Xóa các user/group của Nix."
echo "3. Xóa các file config (dotfiles)."
echo "4. Khôi phục các file hệ thống (/etc/zshrc, /etc/bashrc...) về ban đầu."
echo ""
read -p "Bạn có chắc chắn muốn tiếp tục? (y/N) " confirm

if [[ $confirm != [yY] ]]; then
    echo "Đã hủy."
    exit 1
fi

# --- BƯỚC 1: DỪNG DỊCH VỤ ---
echo -e "\n${YELLOW}[1/6] Dừng dịch vụ Nix Daemon...${NC}"
if [ -f "/Library/LaunchDaemons/org.nixos.nix-daemon.plist" ]; then
    sudo launchctl unload /Library/LaunchDaemons/org.nixos.nix-daemon.plist 2>/dev/null
    sudo rm /Library/LaunchDaemons/org.nixos.nix-daemon.plist
fi
sudo pkill nix-daemon

# --- BƯỚC 2: XÓA USER & GROUP ---
echo -e "\n${YELLOW}[2/6] Xóa User và Group Nix...${NC}"
sudo dscl . -delete /Groups/nixbld 2>/dev/null
for i in $(seq 1 32); do
    sudo dscl . -delete /Users/_nixbld$i 2>/dev/null
done

# --- BƯỚC 3: XÓA Ổ ĐĨA /nix (QUAN TRỌNG) ---
echo -e "\n${YELLOW}[3/6] Gỡ bỏ ổ đĩa APFS /nix...${NC}"
if mount | grep -q "on /nix"; then
    echo "Phát hiện /nix là ổ đĩa. Đang Unmount..."
    sudo diskutil unmount force /nix
    echo "Đang xóa Volume..."
    # Thử xóa bằng tên Volume thường gặp
    sudo diskutil apfs deleteVolume "Nix Store" 2>/dev/null || sudo diskutil apfs deleteVolume /nix 2>/dev/null || echo "⚠️ Không xóa được Volume tự động. Hãy kiểm tra lại Disk Utility."
else
    if [ -d "/nix" ]; then
        echo "/nix là thư mục thường. Đang xóa..."
        sudo rm -rf /nix
    fi
fi

# Xóa các tham chiếu mount
sudo sed -i '' '/^nix/d' /etc/synthetic.conf 2>/dev/null
sudo sed -i '' '/nix/d' /etc/fstab 2>/dev/null
if [ -f "/etc/nix/nix.conf" ]; then
    sudo rm -rf /etc/nix
fi

# --- BƯỚC 4: XÓA FILE RÁC & CONFIG ---
echo -e "\n${YELLOW}[4/6] Dọn dẹp file config cá nhân...${NC}"
rm -rf ~/.nix-profile ~/.nix-defexpr ~/.config/nix
rm -rf ~/.config/nvim ~/.config/wezterm ~/.config/fish ~/.config/starship.toml ~/.tmux.conf ~/.config/lazygit
sudo rm -rf /Applications/Nix\ Apps
sudo rm -rf /run/current-system
sudo rm -rf /etc/profiles/per-user

# --- BƯỚC 5: KHÔI PHỤC FILE HỆ THỐNG (FIX LỖI BASHRC) ---
echo -e "\n${YELLOW}[5/6] Khôi phục file hệ thống gốc (Restore Backups)...${NC}"
# Danh sách các file mà trình cài đặt Nix thường backup
FILES_TO_RESTORE=("bashrc" "zshrc" "bash.bashrc" "synthetic.conf" "profile")

for file in "${FILES_TO_RESTORE[@]}"; do
    BACKUP_FILE="/etc/${file}.backup-before-nix"
    ORIGINAL_FILE="/etc/${file}"
    
    if [ -f "$BACKUP_FILE" ]; then
        echo "✅ Khôi phục: $BACKUP_FILE -> $ORIGINAL_FILE"
        sudo mv "$BACKUP_FILE" "$ORIGINAL_FILE"
    fi
done

# --- BƯỚC 6: TỰ XÓA REPO ---
echo -e "\n${YELLOW}[6/6] Dọn dẹp thư mục cài đặt...${NC}"
# Lưu ý: Lệnh này sẽ xóa chính thư mục chứa script này
rm -rf ~/nix-config

echo -e "\n${GREEN}===========================================${NC}"
echo -e "${GREEN}   MÁY ĐÃ SẠCH BÓNG NIX (FRESH STATE)    ${NC}"
echo -e "${GREEN}===========================================${NC}"
