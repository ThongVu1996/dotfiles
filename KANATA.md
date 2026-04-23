# Cấu hình Bàn phím Kanata (macOS)

Tài liệu này tóm tắt hệ thống remap bàn phím nâng cao đang được sử dụng trong bộ Nix Config này.

## 🚀 Tổng quan
**Kanata** là một công cụ remap bàn phím mạnh mẽ, được tích hợp vào hệ thống thông qua `nix-darwin` (daemon hệ thống) và `home-manager`.

### Các file cấu hình chính:
- `modules/desktop/kanata-system.nix`: Cấu hình daemon khởi động cùng hệ thống.
- `modules/desktop/kanata.nix`: Cài đặt package và quản lý file config.
- `modules/desktop/kanata/config.kbd`: Nơi định nghĩa toàn bộ logic phím.

---

## ✨ Các tính năng đang sử dụng

### 1. Home Row Mods (Tối ưu cho Tmux & AeroSpace)
Các phím hàng cơ sở được gán theo workflow ưu tiên Terminal và điều hướng:
- **Ngón trỏ (`f`, `j`):** **Ctrl** (Dùng nhiều nhất cho Tmux Prefix).
- **Ngón giữa (`d`, `k`):** **Alt / Option** (Dùng để chuyển Workspace AeroSpace).
- **Ngón áp út (`s`, `l`):** **Cmd** (Dùng cho phím tắt hệ thống).
- **Ngón út (`a`, `;`):** **Shift** (Dùng để ghi hoa, ký tự đặc biệt).
- **Cơ chế:** Dùng `tap-hold-release` (170ms) cho cảm giác gõ phím chữ rất nhạy.

### 2. Chords / Hợp âm (Combos)
Nhấn tổ hợp 2 phím cùng lúc để kích hoạt lệnh nhanh:
- **`d + f`** ➔ **Escape** (Thoát nhanh cho Vim/Neovim).
- **`j + k`** ➔ **Backspace** (Xóa nhanh ở tay phải).
- **`k + l`** ➔ **Enter** (Xuống dòng ở tay phải).
- **`c + v`** ➔ **Tab** (Dùng ngón giữa và trỏ tay trái để Tab cực nhanh).
- **`m + ,`** ➔ **Untab (Shift + Tab)** (Dùng ngón trỏ và giữa tay phải để lùi Tab).
- **`x + c`** ➔ **Clear Terminal** (Tự động gõ `clear` + `Enter`).
- **Timeout:** 30ms (Tối ưu để tránh kích hoạt nhầm).

### 3. Mouse & Workflow Layer (Giữ `Space`)
Khi nhấn giữ phím **Space**, bàn phím của bạn sẽ biến thành trung tâm điều khiển chuột và workflow:

#### Điều khiển Chuột:
- **`h j k l`** ➔ **Di chuyển chuột** (Trái/Xuống/Lên/Phải) - *Speed: 10*
- **`u / i / o`** ➔ **Clicks** (Trái / Giữa / Phải)
- **`,` / `.`** ➔ **Scroll** (Cuộn xuống / Cuộn lên) - *Distance: 20*
- **`;` / `'`** ➔ **Browser History** (Quay lại / Tiến tới trang) 🔄

#### Tmux (Quản lý Pane siêu tốc):
- **`s`** ➔ **Split Ngang** (Side-by-side)
- **`v`** ➔ **Split Dọc** (Top-and-bottom)
- **`u`** ➔ **Smart Toggle Copy Mode** (Dùng phím `u` trong Mouse mode)
- **`z`** ➔ **Zoom** (Phóng to/Thu nhỏ Pane)
- **`x`** ➔ **Kill Pane** (Đóng cửa sổ hiện tại)
- **`g`** ➔ **Go to** (Mở danh sách Session/Window)

#### Hệ thống:
- **`q`** ➔ **Quit App** (Cmd + Q)
- **`y`** ➔ **Save File** (Cmd + S)
- **`a`** ➔ **Select All** (Cmd + A)

#### Thao tác trong danh sách Session (Space + g):
- **`j / k`** ➔ Di chuyển lên xuống
- **`f`** ➔ Chọn (Enter)
- **`e`** ➔ Tìm kiếm (/)
- **`a`** ➔ Thoát (q)

### 4. Num, Navigation, Symbols & Media Layers
Tận dụng thói quen "Tay trái điều khiển - Tay phải nhập liệu":

#### Bàn phím số (Giữ `g` + Tay phải):
- **`u i o`** ➔ **7 8 9**
- **`j k l`** ➔ **4 5 6**
- **`m , .`** ➔ **1 2 3**
- **`n`** ➔ **0**
- **`h`** ➔ **.** (Dấu chấm)

#### Điều hướng Arrows (Giữ `v` + Tay phải):
- **`h j k l`** ➔ **← ↓ ↑ →** (Phím mũi tên chuẩn Vim).

#### Ký tự đặc biệt (Giữ `b` + Tay phải):
- **`u i o`** ➔ **& * (**
- **`j k l`** ➔ **$ % ^**
- **`m , .`** ➔ **! @ #**
- **`n`** ➔ **)**
- **`p`** ➔ **Play/Pause Nhạc** ⏸️

#### Media Control (Giữ `c` + Tay phải):
- **`h / l`** ➔ **Giảm / Tăng Độ sáng** ☀️
- **`j / k`** ➔ **Giảm / Tăng Âm lượng** 🔊

### 5. AeroSpace (Chuyển Workspace)
Nhấn các phím sau khi đang giữ Space để nhảy Workspace:
- **`w`** ➔ **Work** (Slack, Discord, Meet,...)
- **`c`** ➔ **Coding & Terminal** (Lập trình)
- **`b`** ➔ **Browser** (Trình duyệt)
- **`n`** ➔ **Notes** (Ghi chú)
- **`m`** ➔ **Media/Music** (Giải trí)

### 6. Hyper Layer (Nhấn giữ CapsLock)
Tổ hợp phím dành riêng cho các thao tác nhanh trong Neovim và hệ thống:
- **`q`** ➔ **Save & Quit** (ZZ): Lưu và đóng cửa sổ nhanh.
- **`w`** ➔ **Save All** (:wa): Lưu tất cả các buffer đang mở.
- **`x`** ➔ **Quit No Save** (ZQ): Thoát nhanh không cần lưu.
- **`t` / `a` / `k`** ➔ Các lệnh Hyper đặc biệt khác.

---

## 🛠 Quản lý & Bảo trì
- **Build & Apply:** `nix-ss`
- **Kiểm tra thiết bị (Lấy Hash ID):** `kanata --list`
- **Check Logs:** `sudo tail -f /Library/Logs/kanata.out.log`
- **Check Errors:** `sudo tail -f /Library/Logs/kanata.err.log`

### Cách thêm bàn phím mới:
Nếu bạn đổi bàn phím hoặc muốn Kanata nhận thêm thiết bị khác, hãy thực hiện các bước sau:
1. Chạy lệnh `kanata --list` để lấy mã **Hash ID** của bàn phím mới (ví dụ: `0xABCD...`).
2. Mở file `modules/desktop/kanata/config.kbd`.
3. Thêm mã Hash vừa lấy được vào danh sách `macos-dev-names-include` trong khối `(defcfg)`:
   ```lisp
   (defcfg
     macos-dev-names-include (
       "0xD4359520DA829EC8" ;; Apple Internal
       "0xE329BEB8F1D4D729" ;; M71
       "0xABCD..."         ;; Bàn phím mới của bạn
     )
   )
   ```
4. Chạy `nix-ss` để áp dụng.

> [!IMPORTANT]
> Nếu bàn phím không hoạt động, hãy đảm bảo đã cấp quyền **Input Monitoring** cho binary `kanata` trong Nix Store tại **System Settings > Privacy & Security**.