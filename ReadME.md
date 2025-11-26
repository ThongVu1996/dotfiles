# **Hướng dẫn Cài đặt và Gỡ bỏ Nix & Nix-Darwin**

Tài liệu này hướng dẫn cách thiết lập môi trường Nix trên macOS sử dụng bộ cài đặt của Determinate Systems và cấu hình nix-darwin. Đồng thời cung cấp quy trình gỡ bỏ sạch sẽ (clean uninstall) khi cần thiết.

## **1\. Cài đặt (Installation)**

Thực hiện lần lượt các lệnh sau trong Terminal:

### **Bước 1: Cài đặt Nix (Determinate Systems)**

```
curl \--proto '=https' \--tlsv1.2 \-sSf \-L \[https://install.determinate.systems/nix\](https://install.determinate.systems/nix) | sh \-s \-- install
```

### **Bước 2: Xử lý xung đột chứng chỉ SSL**

Đổi tên file chứng chỉ cũ để tránh lỗi khi kích hoạt nix-darwin:

```
sudo mv /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt.backup
```

### **Bước 3: Nạp môi trường Nix**

Kích hoạt Nix trong phiên làm việc hiện tại (hoặc tắt Terminal bật lại):

```
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
```

### **Bước 4: Kích hoạt Nix-Darwin**

Chạy lệnh switch để build hệ thống (Lưu ý thay \#MacBook-Pro bằng hostname của bạn nếu khác):

```
sudo nix run nix-darwin \-- switch \--flake .\#MacBook-Pro
```

### **Buớc 5: Cài đặt fish shell làm mặc định**

```
# Thêm fish vào danh sách allowed shells (nếu flake chưa làm xong)
sudo sh -c 'echo /run/current-system/sw/bin/fish >> /etc/shells'

# Đổi shell mặc định sang fish
chsh -s /run/current-system/sw/bin/fish
```

## **2\. Gỡ bỏ (Uninstallation)**

Nếu bạn muốn gỡ sạch toàn bộ để cài lại từ đầu, hãy làm theo các bước dưới đây.

### **Bước 1: Chạy trình gỡ cài đặt của Nix-Darwin**

Tạo file giả synthetic.conf (để tránh lỗi) và chạy uninstaller:

```
sudo touch /etc/synthetic.conf
sudo nix \--extra-experimental-features "nix-command flakes" run nix-darwin\#darwin-uninstaller
```

### **Bước 2: Xóa thủ công (Nuclear Option)**

Nếu trình gỡ cài đặt chưa sạch hoặc báo lỗi, hãy chạy các lệnh sau để xóa tận gốc:

**1\. Dừng các services:**

```
sudo launchctl remove org.nixos.nix-daemon
sudo launchctl remove org.nixos.darwin-store
```

**2\. Xóa các user và group của Nix:**

```
sudo dscl . \-delete /Groups/nixbld
for i in $(dscl . \-list /Users | grep \_nixbld); do sudo dscl . \-delete /Users/$i; done
```

**3\. Xóa thư mục Nix (Quan trọng nhất):**

```
sudo rm \-rf /nix
```

**4\. Xóa các file cấu hình còn sót lại trong /etc:**

Trước tiên hãy check để thay thế vào các file flake.nix và home.nix cho hợp lý

```
whoami # kiểm trả username
scutil --get LocalHostName # kiểm tra hostname
```

```
sudo rm \-rf /etc/nix
sudo rm \-f /etc/synthetic.conf
```

### **Bước 3: Hoàn tất**

Sau khi thực hiện xong, hãy **Khởi động lại máy (Restart)** để hệ thống sạch hoàn toàn.

## **Tham khảo**

Để biết thêm chi tiết, bạn có thể xem tài liệu gốc tại:

- [Nix-Darwin Uninstallation Guide](https://www.google.com/search?q=https://github.com/nix-darwin/nix-darwin%23uninstalling-for-instructions-how-to-uninstall-nix-darwin)

## Note

**Tạo môi trường cho dự án**

```
setupflake
```

**Kiểm tra dung lượng đã chiếm**

```
sudo rm \-rf /etc/nix
sudo rm \-f /etc/synthetic.conf
```

**Dọn rác**

```bash
nix-collect-garbage -d
# Hoặc xóa rác hệ thống (cần sudo)
sudo nix-collect-garbage -d
```

**Optimize**

```bash
nix-store --optimise
```
