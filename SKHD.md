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

Khi bạn giữ phím `Space` và bấm các phím tương ứng, Kanata sẽ gửi chuỗi tín hiệu `F13` đến `F19`. `skhd` sẽ nhận các phím `F` này và chuyển quyền xử lý cho `skhd_dispatcher.sh`.

### Cơ chế hoạt động:
1. `skhdrc` kích hoạt: `f14 : /.../skhd_dispatcher.sh "s" "cmd - s"`
2. Script chạy `osascript` để lấy tên ứng dụng đang Focus.
3. Nếu ứng dụng là `rio` (Terminal hiện hành): script tự động gửi Tổ hợp phím Tmux `Ctrl+A`, tạm dừng nhẹ 0.05s, rồi gửi phím tmux tiếp theo.
4. Nếu ứng dụng khác: script gửi lệnh Global (như `Cmd+S`).

### Bảng Phím tắt Ngữ cảnh:
| Phím Kanata | Tín hiệu | Hành động trong Rio (Terminal) | Hành động Cầu (Global) |
| :--- | :--- | :--- | :--- |
| `Space + S` | `F14` | Tmux: Split Ngang (`Ctrl+A`, `S`) | Lưu file (`Cmd + S`) |
| `Space + V` | `F15` | Tmux: Split Dọc (`Ctrl+A`, `V`) | Lưu file (`Cmd + S`) |
| `Space + Z` | `F16` | Tmux: Zoom Pane (`Ctrl+A`, `Z`) | *(Không có)* |
| `Space + X` | `F17` | Tmux: Kill Pane (`Ctrl+A`, `X`) | *(Không có)* |
| `Space + G` | `F19` | Tmux: View Sessions (`Ctrl+A`, `W`)| *(Không có)* |

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
