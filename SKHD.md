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

Khi bạn giữ phím `Space` và bấm các phím tương ứng, Kanata sẽ gửi chuỗi tín hiệu **`F20` đến `F24`** (Dải phím an toàn để lách các phím cứng mặc định của macOS như Brightness/Volume). `skhd` sẽ nhận các phím `F` này và chuyển quyền xử lý cho `skhd_dispatcher.sh`.

### Cơ chế hoạt động:
1. `skhdrc` kích hoạt: `f21 : /.../skhd_dispatcher.sh "s" "cmd - s"`
2. Script chạy `osascript` để lấy tên ứng dụng đang Focus.
3. Nếu ứng dụng là `rio` (Terminal hiện hành): script tự động gửi Tổ hợp phím Tmux `Ctrl+A`, tạm dừng nhẹ 0.05s, rồi gửi phím tmux tiếp theo.
4. Nếu ứng dụng khác: script gửi lệnh Global (như `Cmd+S`).

### Bảng Phím tắt Ngữ cảnh (Space Layer):
| Phím Kanata | Tín hiệu | Hành động trong Rio (Terminal) | Hành động Global (Mặc định) |
| :--- | :--- | :--- | :--- |
| `Space + Q` | `F20` | *(Không có)* | Thoát App (`Cmd + Q`) |
| `Space + S` | `F21` | Tmux: Split-H (`Ctrl+A`, `s`) | Lưu file (`Cmd + S`) |
| `Space + Y` | `F22` | Tmux: Split-V (`Ctrl+A`, `v`) | Lưu file (`Cmd + S`) |
| `Space + Z` | `F23` | Tmux: Zoom Pane (`Ctrl+A`, `z`) | *(Không có)* |
| `Space + X` | `F24` | Tmux: Kill Pane (`Ctrl+A`, `x`) | *(Không có)* |
| `Space + V` | `S-F21` | Tmux: Split Vertical (`Ctrl+A`, `v`) | *(Không có)* |
| `Space + G` | `S-F22` | Tmux: Session/Window (`Ctrl+A`, `w`) | *(Không có)* |

---

## 🔊 3. Precision Media Control (C Layer)

MacOS mặc định chì chia âm lượng/độ sáng thành 16 nấc (khá thô). Hệ thống của chúng ta sử dụng Kanata làm tín hiệu và SKHD làm "hành động" để chia nhỏ thành **50-64 nấc** siêu mịn (mỗi lần bấm dịch chuyển đúng 2%).

| Phím Kanata | Tín hiệu | Hành động điều khiển | Chi tiết kỹ thuật |
| :--- | :--- | :--- | :--- |
| `C + H` | `S-F1` | Giảm Độ Sáng mịn (-2%) | BetterDisplay URL Scheme |
| `C + L` | `S-F2` | Tăng Độ Sáng mịn (+2%) | BetterDisplay URL Scheme |
| `C + J` | `S-F9` | Giảm Âm Lượng mịn (-2%) | AppleScript `output volume` |
| `C + K` | `S-F10` | Tăng Âm Lượng mịn (+2%) | AppleScript `output volume` |

---

## 🚀 2. Application Launchers & System (Hyper Layer)

Khi bạn kích hoạt `Hyper` (thường bằng thao tác nhấn đè CapsLock) cộng với 1 phím chữ, Kanata sẽ gửi tổ hợp `Cmd + Alt + Ctrl + Shift + Phím`. 

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
  cat /Library/Logs/skhd/skhd.err.log
  ```
- Nếu `skhd` bị dừng đột ngột, khởi động lại nó bằng:
  ```bash
  launchctl stop org.nix-community.home.skhd && launchctl start org.nix-community.home.skhd
  ```
- Nếu thay đổi các phím trong `skhdrc`, bạn cần chạy:
  ```bash
  nix-ss
  ```
  *(Vì NixOS sẽ copy file cấu hình vào `/nix/store` mỗi khi rebuild).*

---

## 🚨 Post-Mortem: Tóm tắt bài học Debug SKHD (Sự cố mất Hotkey)

Dưới đây là chuỗi sự cố "kinh điển" đã xảy ra và dẫn đến mất toàn bộ phím tắt (cả Hyper và phím tắt Space), cùng với bài học xương máu:

1. Thêm nhầm cấu hình `[app="rio"]` sai cú pháp vào file `skhdrc`
   **↓**
2. `skhd` gặp lỗi Parse Error, không load cấu hình
   **↓**
3. Mọi shortcut đều "chết" (Hyper A, B, T, E và Space + S đều không hoạt động)
   **↓**
4. Rebuild bằng Nix để sửa lỗi Fix Syntax nhưng dịch vụ SKHD không Restart đúng cách (bị rác tiến trình)
   **↓**
5. Lỗi cũ in ra file log từ đời nào che lấp mất lỗi thực tế → Debug bị kéo dài và lệch hướng không ngừng
   **↓**
6. Tới khi **Xóa sạch Log + Kill tiến trình** thì SKHD mới restart sạch sẽ → Load cấu hình mới và chạy trơn tru 100%.

> [!IMPORTANT]
> **BÀI HỌC:** Khi SKHD có vẻ không nhận bất kỳ shortcut nào cả, việc đầu tiên và kiên quyết phải làm để xác định đúng nguyên nhân là chạy khối lệnh "Clear State" sau:

```bash
# Bỏ hoàn toàn file rác / rỗng log để biết lỗi hiện tại
rm ~/Library/Logs/skhd/skhd.err.log

# Bắt buộc ép kill toàn bộ tiến trình ảo của skhd
sudo kill -9 $(pgrep skhd)

# Đợi hệ thống tự kéo skhd (launchd) lên lại
sleep 5

# Đọc log thật sự mới mẻ nhất
cat ~/Library/Logs/skhd/skhd.err.log
```
