# Hệ thống SKHD & Context-Aware Dispatcher

Tài liệu này mô tả kiến trúc Quản lý Phím tắt Hệ thống (SKHD) được tùy chỉnh đặc biệt để tương tác mượt mà với bàn phím Kanata, khắc phục triệt để lỗi parse của cấu hình mặc định.

## 🚀 Ý tưởng cốt lõi (Clean Architecture)

- **Kanata:** Chỉ làm nhiệm vụ điều phối và gửi các phím tín hiệu chuẩn (ví dụ: gửi `F13` - `F19` hoặc gửi chính xác cụm phím `Cmd+Ctrl+Alt+Shift+<key>`).
- **SKHD:** Làm nhiệm vụ bắt các tín hiệu này và biến chúng thành các thao tác điều khiển ứng dụng và quản lý Layout.
- **Dispatcher Script:** Chịu trách nhiệm kiểm tra ngữ cảnh (app nào đang được mở) để thực thi lệnh phù hợp.

## 📁 Cấu trúc thư mục

- `dotfiles/skhd/skhdrc`: File cấu hình lõi của `skhd`. Định nghĩa cách bắt phím `Hyper` và `F-keys` từ Kanata.
- `dotfiles/skhd/scripts/skhd_dispatcher.sh`: Shell script thay thế toàn bộ logic lọc ứng dụng `[app="..."]` bị lỗi của `skhd`. Script này có thể đọc trạng thái hiện hành từ macOS an toàn tuyệt đối 100%.

---

## ⚡ 1. Context-Aware Shortcuts (Space Layer)

Khi bạn giữ phím `Space` và bấm các phím tương ứng, Kanata sẽ gửi chuỗi tín hiệu **`F13`, `F16`-`F19`, `S-F16`, `S-F17`** (Dải phím an toàn). `skhd` sẽ nhận các phím `F` này và chuyển quyền xử lý cho `skhd_dispatcher.sh`.

### Cơ chế hoạt động:
1. `skhdrc` kích hoạt: `f16 : /.../skhd_dispatcher.sh "s" "cmd - s"`
2. Script chạy `osascript` để lấy tên ứng dụng đang Focus.
3. Nếu ứng dụng là `rio` (Terminal hiện hành): script tự động gửi Tổ hợp phím Tmux `Ctrl+A`, tạm dừng nhẹ 0.05s, rồi gửi phím tmux tiếp theo.
4. Nếu ứng dụng khác: script gửi lệnh Global (như `Cmd+S`).

### Bảng Phím tắt Ngữ cảnh (Space Layer):
| Phím Kanata | Tín hiệu | Hành động trong Rio (Terminal) | Hành động Global (Mặc định) |
| :--- | :--- | :--- | :--- |
| `Space + Q` | `F13` | *(Không có)* | Thoát App (`Cmd + Q`) |
| `Space + S` | `F16` | Tmux: Split-H (`Ctrl+A`, `s`) | Lưu file (`Cmd + S`) |
| `Space + Y` | `F17` | Tmux: Split-V (`Ctrl+A`, `v`) | Lưu file (`Cmd + S`) |
| `Space + Z` | `F18` | Tmux: Zoom Pane (`Ctrl+A`, `z`) | *(Không có)* |
| `Space + X` | `F19` | Tmux: Kill Pane (`Ctrl+A`, `x`) | *(Không có)* |
| `Space + V` | `S-F16` | Tmux: Split Vertical (`Ctrl+A`, `v`) | *(Không có)* |
| `Space + G` | `S-F17` | Tmux: Session/Window (`Ctrl+A`, `w`) | *(Không có)* |

---

## 🔊 2. Media Control (C Layer)

Giữ `C` rồi nhấn các phím tương ứng để điều khiển âm lượng, độ sáng và media.

### Bảng Phím tắt Media (C Layer):
| Phím Kanata | Hành động | Chi tiết kỹ thuật |
| :--- | :--- | :--- |
| `C + H` | Giảm Độ Sáng (`Option+Shift+BrDn`) | Native macOS fine-tune |
| `C + L` | Tăng Độ Sáng (`Option+Shift+BrUp`) | Native macOS fine-tune |
| `C + J` | Giảm Âm Lượng (`Option+Shift+VolDn`) | Native macOS fine-tune |
| `C + K` | Tăng Âm Lượng (`Option+Shift+VolUp`) | Native macOS fine-tune |
| `C + M` | Mute/Unmute | Native macOS `mute` key |
| `C + ,` | Bài trước / Tua lại | Native app: `prev` media key / Web (YouTube): keystroke `j` |
| `C + .` | Bài tiếp / Tua tới | Native app: `next` media key / Web (YouTube): keystroke `l` |
| `C + /` | Play/Pause | Native app: `pp` media key / Web (YouTube): keystroke `k` |

> **Lưu ý:** `C + ,`, `C + .`, `C + /` hoạt động context-aware:
> - **Native app** (Spotify, Music.app...): gửi media key `prev`/`next`/`pp`
> - **Web browser** (YouTube...): gửi keystroke `j`/`l`/`k` trực tiếp vào trang

---

## 🚀 3. Application Launchers & System (Hyper Layer)

Khi bạn kích hoạt `Hyper` (giữ CapsLock) cộng với 1 phím chữ, Kanata sẽ gửi tổ hợp `Cmd + Alt + Ctrl + Shift + Phím`.

`skhd` sẽ hứng trực tiếp tổ hợp `Hyper` này để thực thi thao tác cấu hình dưới đây:

### Nhóm Mở Ứng dụng:
- **`Hyper + A`**: Mở Antigravity
- **`Hyper + K`**: Mở KeePassXC
- **`Hyper + B`**: Mở Zen Browser
- **`Hyper + T`**: Mở Rio Terminal
- **`Hyper + E`**: Mở Finder (Thư mục Home)

### Nhóm Điều khiển Hệ thống:
- **`Hyper + S`**: Sleep màn hình ngay lập tức.
- **`Hyper + M`**: Tắt/Bật (Mute) Microphone.
- **`Hyper + L`**: Khóa màn hình (Lock Screen).
- **`Hyper + D`**: Chụp màn hình khoanh vùng (Lưu vào Desktop).
- **`Hyper + F`**: Chụp màn hình toàn màn hình (Lưu vào Desktop).
- **`Hyper + R`**: Tải lại cấu hình AeroSpace (`aerospace reload-config`).

---

## 🛠 Cách bảo trì và khắc phục sự cố

- Xem Log hệ thống để kiểm tra lỗi của SKHD:
  ```bash
  cat ~/Library/Logs/skhd/skhd.err.log
  ```
- Nếu `skhd` bị dừng đột ngột, khởi động lại nó bằng:
  ```bash
  launchctl kickstart -k gui/$(id -u)/org.nix-community.home.skhd
  ```
- Nếu thay đổi các phím trong `skhdrc` hoặc `config.kbd`, bạn cần chạy:
  ```bash
  darwin-rebuild switch --flake /Users/thongvu/nix-config
  ```
- Nếu không thấy apply config kanata mới nhất:
  ```bash
  sudo rm /Library/Logs/kanata.err.log && sudo kill -9 $(pgrep kanata) && sleep 5 && cat /Library/Logs/kanata.err.log
  ```

---

## 🚨 Post-Mortem: Tóm tắt bài học Debug (Sự cố mất Hotkey)

### SKHD mất toàn bộ phím tắt

1. Thêm nhầm cấu hình `[app="rio"]` sai cú pháp vào file `skhdrc`
   **↓**
2. `skhd` gặp lỗi Parse Error, không load cấu hình
   **↓**
3. Mọi shortcut đều "chết" (Hyper A, B, T, E và Space + S đều không hoạt động)
   **↓**
4. Rebuild bằng Nix để sửa lỗi nhưng SKHD không restart đúng cách
   **↓**
5. Log cũ che lấp lỗi thực tế → Debug bị kéo dài và lệch hướng
   **↓**
6. Xóa sạch Log + Kill tiến trình → SKHD restart sạch → Load config mới → OK

> [!IMPORTANT]
> **BÀI HỌC SKHD:** Khi SKHD không nhận bất kỳ shortcut nào, chạy ngay:
> ```bash
> rm ~/Library/Logs/skhd/skhd.err.log
> sudo kill -9 $(pgrep skhd)
> sleep 5
> cat ~/Library/Logs/skhd/skhd.err.log
> ```

### Kanata không load config mới

1. Sửa config nhưng quên rebuild → Nix store vẫn là bản cũ
2. Kanata parse error → bàn phím không hoạt động
3. Log cũ không bị xóa → không biết lỗi thực tế là gì

> [!IMPORTANT]
> **BÀI HỌC KANATA:** Sau mỗi lần sửa config:
> ```bash
> # 1. Rebuild để Nix tạo hash mới
> darwin-rebuild switch --flake /Users/thongvu/nix-config
>
> # 2. Xóa log cũ + restart Kanata
> sudo rm /Library/Logs/kanata.err.log
> sudo kill -9 $(pgrep kanata)
> sleep 5
> cat /Library/Logs/kanata.err.log
> ```
> Log trống = thành công. Log có lỗi = đọc lỗi và fix.

### Verify config đang chạy đúng chưa
```bash
# Kanata đang dùng config nào
/bin/ps -p $(pgrep kanata | head -1) -o args=

# SKHD có load config không
lsof -p $(pgrep skhd | head -1) | grep skhdrc

# Symlink trỏ đúng chưa
readlink ~/.config/skhd/skhdrc
readlink /etc/kanata/config.kbd
``` 

### Reload config 
```bash
skhd --reload
``` 