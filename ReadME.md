# **Hướng dẫn Cài đặt và Quản lý Nix (Nix-Darwin)**

Tài liệu này hướng dẫn chi tiết cách gỡ bỏ sạch Nix cũ, cài đặt lại Nix mới thông qua _Determinate Systems Installer_, và áp dụng cấu hình từ repository dotfiles.

## **1\. Chuẩn bị (Clone Config)**

Trước tiên, hãy clone repository chứa cấu hình về máy:

```
git clone \-b feature/2025\_12\_01/Nix git@github.com:ThongVu1996/dotfiles.git \~/nix-config
```

## **2\. Quy trình Gỡ bỏ Nix (Uninstall)**

Nếu máy đã từng cài Nix, hãy thực hiện các bước sau để gỡ bỏ sạch sẽ.

### **Bước 1: Xóa Users và Groups của Nix**

Chạy các lệnh sau trong Terminal để xóa nhóm và người dùng build của Nix:

```
sudo dscl . \-delete /Groups/nixbld 2\>/dev/null
for i in $(dscl . \-list /Users | grep \_nixbld); do sudo dscl . \-delete /Users/$i; done

```

### **Bước 2: Dọn dẹp file cấu hình Shell**

Bạn cần xóa các dòng code liên quan đến nix-daemon trong các file cấu hình shell.

- Mở và chỉnh sửa file .zshrc:

  ```
  nano \~/.zshrc
  \# Tìm và xóa các đoạn code liên quan đến nix-daemon, sau đó lưu lại (Ctrl+O \-\> Enter \-\> Ctrl+X)
  ```

- Mở và chỉnh sửa file /etc/bashrc:
  ```
  sudo nano /etc/bashrc
  \# Tìm và xóa các đoạn code liên quan đến nix-daemon
  ```

### **Bước 3: Xóa các file hệ thống Nix**

```
sudo rm \-rf /etc/nix /var/root/.nix-profile /var/root/.nix-defexpr /var/root/.nix-channels
sudo rm /etc/synthetic.conf 2\>/dev/null

```

### **Bước 4: Xóa APFS Volume (Nix Store)**

1. Mở ứng dụng **Disk Utility**.
2. Tìm volume có tên **Nix Store** (thường nằm cùng nhóm container với Macintosh HD).
3. Nhấn chuột phải vào "Nix Store" \-\> Chọn **Delete APFS Volume**.

### **Bước 5: Khởi động lại máy**

**Lưu ý:** Bắt buộc khởi động lại máy (Restart) trước khi chuyển sang phần cài đặt.

## **3\. Quy trình Cài đặt (Install)**

### **Bước 1: Chuẩn bị môi trường**

Mở Terminal, đảm bảo bạn đang sử dụng zsh (nhấn Command \+ Shift \+ N hoặc gõ /bin/zsh).

Chạy lệnh sau để xóa mật khẩu mã hóa volume cũ (nếu có) trong Keychain:

```
sudo security delete-generic-password \-a "Nix Store" \-s "Nix Store" \-D "Encrypted volume password"

```

_Kiểm tra lại:_ Mở nano \~/.zshrc một lần nữa để chắc chắn không còn tàn dư của nix-daemon cũ.

### **Bước 2: Cài đặt Nix (Determinate Systems Installer)**

Chạy lệnh cài đặt sau:

```
curl \--proto '=https' \--tlsv1.2 \-sSf \-L \[https://install.determinate.systems/nix\](https://install.determinate.systems/nix) | sh \-s \-- install
```

Sau khi cài xong, hãy **tắt Terminal và mở lại** để nạp cấu hình mới.

### **Bước 3: Kích hoạt và Apply cấu hình**

Kích hoạt daemon và thêm vào file khởi động shell:

```
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

echo "if \[ \-e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' \]; then . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'; fi" \>\> \~/.zshrc
```

Di chuyển vào thư mục config và build hệ thống (thay thế \#MacBook-Pro bằng tên flake của bạn nếu khác):

```
cd \~/nix-config
sudo nix run nix-darwin \-- switch \--flake .\#MacBook-Pro
```

## **4\. Thiết lập Shell mặc định (Fish Shell)**

Sau khi cài đặt xong nix-darwin, nếu bạn muốn dùng Fish shell làm mặc định:

```
\# Thêm đường dẫn fish vào danh sách shells hợp lệ
sudo sh \-c 'echo $(which fish) \>\> /etc/shells'

\# Đổi shell mặc định sang fish
sudo chsh \-s $(which fish)
```

### **Bước cuối cùng**

Khởi động lại máy (Restart) để toàn bộ thay đổi có hiệu lực.

## Note

**Tìm đến tận cùng path được quản lý bởi nix**

```
readlink -f $(which node) #Thay node bằng tên phần mềm
```

**Setup môi trường dev cho project**

```
setupflake
```

**Xóa các file không còn dùng đến nữa - an toàn**

```
nix-collect-garbage
```
