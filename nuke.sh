#!/bin/bash

# --- CẤU HÌNH MÀU SẮC ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${RED}!!! CẢNH BÁO: CHẾ ĐỘ HỦY DIỆT (FINAL NUKE V2) !!!${NC}"
echo "Script này sẽ xóa sạch Nix, bao gồm cả Keychain và Config."
read -p "Bạn có chắc chắn muốn tiếp tục? (y/N) " confirm

if [[ $confirm != [yY] ]]; then
    echo "Đã hủy."
    exit 1
fi

# --- BƯỚC 1: DỪNG DỊCH VỤ ---
echo -e "\n${YELLOW}[1/8] Dừng dịch vụ Nix Daemon...${NC}"
if [ -f "/Library/LaunchDaemons/org.nixos.nix-daemon.plist" ]; then
    sudo launchctl unload /Library/LaunchDaemons/org.nixos.nix-daemon.plist 2>/dev/null
    sudo rm /Library/LaunchDaemons/org.nixos.nix-daemon.plist
fi
sudo pkill nix-daemon

# --- BƯỚC 2: XÓA KEYCHAIN (FIX LỖI DETERMINATE INSTALLER) ---
echo -e "\n${YELLOW}[2/8] Dọn dẹp mật khẩu Nix Store trong Keychain...${NC}"
# Chạy lệnh xóa cho đến khi không còn tìm thấy item nào
while sudo security delete-generic-password -a "Nix Store" -s "Nix Store" -D "Encrypted volume password" 2>/dev/null; do
    echo "Đã xóa một key cũ..."
done
echo "Keychain đã sạch."

# --- BƯỚC 3: XÓA USER & GROUP ---
echo -e "\n${YELLOW}[3/8] Xóa User và Group Nix...${NC}"
sudo dscl . -delete /Groups/nixbld 2>/dev/null
for i in $(seq 1 32); do
    sudo dscl . -delete /Users/_nixbld$i 2>/dev/null
done

# --- BƯỚC 4: XÓA Ổ ĐĨA /nix ---
echo -e "\n${YELLOW}[4/8] Gỡ bỏ ổ đĩa APFS /nix...${NC}"
# Tắt service giữ ổ đĩa (nếu có)
sudo launchctl bootout system/org.nixos.darwin-store 2>/dev/null

if mount | grep -q "on /nix"; then
    echo "Đang Force Unmount /nix..."
    sudo diskutil unmount force /nix
    echo "Đang xóa Volume 'Nix Store'..."
    sudo diskutil apfs deleteVolume "Nix Store" 2>/dev/null || sudo diskutil apfs deleteVolume /nix 2>/dev/null
else
    if [ -d "/nix" ]; then
        echo "/nix là thư mục thường. Đang xóa..."
        sudo rm -rf /nix
    fi
fi

# Xóa tham chiếu mount
sudo sed -i '' '/^nix/d' /etc/synthetic.conf 2>/dev/null
sudo sed -i '' '/nix/d' /etc/fstab 2>/dev/null
if [ ! -s "/etc/synthetic.conf" ]; then sudo rm -f "/etc/synthetic.conf"; fi

# --- BƯỚC 5: DỌN DẸP SSL HACK ---
echo -e "\n${YELLOW}[5/8] Dọn dẹp cấu hình SSL Hack...${NC}"
if [ -L "/etc/ssl/certs/ca-certificates.crt" ]; then
    sudo rm "/etc/ssl/certs/ca-certificates.crt"
    sudo rmdir "/etc/ssl/certs" 2>/dev/null || true
fi

# --- BƯỚC 6: DỌN DẸP FILE CONFIG ---
echo -e "\n${YELLOW}[6/8] Dọn dẹp file config cá nhân...${NC}"
sudo rm -rf /etc/nix
rm -rf ~/.nix-profile ~/.nix-defexpr ~/.config/nix
rm -rf ~/.config/nvim ~/.config/wezterm ~/.config/fish ~/.config/starship.toml ~/.tmux.conf ~/.config/lazygit
sudo rm -rf /Applications/Nix\ Apps
sudo rm -rf /run/current-system
sudo rm -rf /etc/profiles/per-user

# --- BƯỚC 7: KHÔI PHỤC FILE HỆ THỐNG ---
echo -e "\n${YELLOW}[7/8] Khôi phục file hệ thống gốc...${NC}"
FILES=("bashrc" "zshrc" "bash.bashrc" "synthetic.conf" "profile")
for file in "${FILES[@]}"; do
    BACKUP="/etc/${file}.backup-before-nix"
    TARGET="/etc/${file}"
    if [ -f "$BACKUP" ]; then
        echo "✅ Khôi phục: $BACKUP -> $TARGET"
        sudo mv "$BACKUP" "$TARGET"
    fi
done

# --- BƯỚC 8: TỰ XÓA REPO ---
echo -e "\n${YELLOW}[8/8] Dọn dẹp thư mục cài đặt...${NC}"
rm -rf ~/nix-config

echo -e "\n${GREEN}===========================================${NC}"
echo -e "${GREEN}   MÁY ĐÃ SẠCH BÓNG NIX (FRESH STATE)    ${NC}"
echo -e "${GREEN}===========================================${NC}"
