#!/bin/bash

# --- CẤU HÌNH MÀU SẮC ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${RED}!!! CẢNH BÁO: CHẾ ĐỘ HỦY DIỆT (FINAL NUKE) !!!${NC}"
echo "Script này sẽ xóa sạch Nix, các cấu hình liên quan và khôi phục máy về trạng thái gốc."
echo "1. Gỡ bỏ ổ đĩa /nix (APFS Volume)."
echo "2. Xóa Users/Groups của Nix."
echo "3. Xóa các file config (bao gồm cả thủ thuật SSL Fix)."
echo "4. Khôi phục file hệ thống gốc."
echo ""
read -p "Bạn có chắc chắn muốn tiếp tục? (y/N) " confirm

if [[ $confirm != [yY] ]]; then
    echo "Đã hủy."
    exit 1
fi

# --- BƯỚC 1: DỪNG DỊCH VỤ ---
echo -e "\n${YELLOW}[1/7] Dừng dịch vụ Nix Daemon...${NC}"
if [ -f "/Library/LaunchDaemons/org.nixos.nix-daemon.plist" ]; then
    sudo launchctl unload /Library/LaunchDaemons/org.nixos.nix-daemon.plist 2>/dev/null
    sudo rm /Library/LaunchDaemons/org.nixos.nix-daemon.plist
fi
sudo pkill nix-daemon

# --- BƯỚC 2: XÓA USER & GROUP ---
echo -e "\n${YELLOW}[2/7] Xóa User và Group Nix...${NC}"
sudo dscl . -delete /Groups/nixbld 2>/dev/null
for i in $(seq 1 32); do
    sudo dscl . -delete /Users/_nixbld$i 2>/dev/null
done

# --- BƯỚC 3: XÓA Ổ ĐĨA /nix (FIX LỖI RESOURCE BUSY) ---
echo -e "\n${YELLOW}[3/7] Gỡ bỏ ổ đĩa APFS /nix...${NC}"
if mount | grep -q "on /nix"; then
    echo "Phát hiện /nix là ổ đĩa. Đang Force Unmount..."
    sudo diskutil unmount force /nix
    echo "Đang xóa Volume 'Nix Store'..."
    # Thử xóa bằng tên, nếu không được thì xóa bằng đường dẫn mount point
    sudo diskutil apfs deleteVolume "Nix Store" 2>/dev/null || sudo diskutil apfs deleteVolume /nix 2>/dev/null || echo "⚠️ Cảnh báo: Không xóa được tự động. Hãy kiểm tra Disk Utility."
else
    if [ -d "/nix" ]; then
        echo "/nix là thư mục thường. Đang xóa..."
        sudo rm -rf /nix
    fi
fi

# Xóa tham chiếu mount trong synthetic.conf và fstab
sudo sed -i '' '/^nix/d' /etc/synthetic.conf 2>/dev/null
sudo sed -i '' '/nix/d' /etc/fstab 2>/dev/null
# Xóa file synthetic.conf nếu nó rỗng
if [ ! -s "/etc/synthetic.conf" ]; then sudo rm -f "/etc/synthetic.conf"; fi

# --- BƯỚC 4: DỌN DẸP "THỦ THUẬT SSL" ---
echo -e "\n${YELLOW}[4/7] Dọn dẹp cấu hình SSL Hack (Linux Simulation)...${NC}"
# Xóa symlink ta đã tạo trong install.sh để fix lỗi SSL
if [ -L "/etc/ssl/certs/ca-certificates.crt" ]; then
    sudo rm "/etc/ssl/certs/ca-certificates.crt"
    # Xóa thư mục nếu rỗng
    sudo rmdir "/etc/ssl/certs" 2>/dev/null || true
fi

# --- BƯỚC 5: DỌN DẸP FILE RÁC & CONFIG ---
echo -e "\n${YELLOW}[5/7] Dọn dẹp file config cá nhân...${NC}"
sudo rm -rf /etc/nix
rm -rf ~/.nix-profile ~/.nix-defexpr ~/.config/nix
rm -rf ~/.config/nvim ~/.config/wezterm ~/.config/fish ~/.config/starship.toml ~/.tmux.conf ~/.config/lazygit
sudo rm -rf /Applications/Nix\ Apps
sudo rm -rf /run/current-system
sudo rm -rf /etc/profiles/per-user

# --- BƯỚC 6: KHÔI PHỤC FILE HỆ THỐNG ---
echo -e "\n${YELLOW}[6/7] Khôi phục file hệ thống gốc...${NC}"
# Danh sách đầy đủ các file cần restore
FILES=("bashrc" "zshrc" "bash.bashrc" "synthetic.conf" "profile")

for file in "${FILES[@]}"; do
    BACKUP="/etc/${file}.backup-before-nix"
    TARGET="/etc/${file}"
    
    if [ -f "$BACKUP" ]; then
        echo "✅ Khôi phục: $BACKUP -> $TARGET"
        sudo mv "$BACKUP" "$TARGET"
    fi
done

# --- BƯỚC 7: TỰ XÓA REPO ---
echo -e "\n${YELLOW}[7/7] Dọn dẹp thư mục cài đặt...${NC}"
rm -rf ~/nix-config

echo -e "\n${GREEN}===========================================${NC}"
echo -e "${GREEN}   MÁY ĐÃ SẠCH BÓNG NIX (FRESH STATE)    ${NC}"
echo -e "${GREEN}===========================================${NC}"
