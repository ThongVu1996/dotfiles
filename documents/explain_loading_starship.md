# **Cơ chế Loading Starship trong Nushell**

Tài liệu này giải thích cách Starship khởi tạo và vận hành bên trong Nushell, đặc biệt trong ngữ cảnh hệ thống sử dụng Nix/Home Manager để quản lý file cấu hình.

## **1\. Sơ đồ luồng hoạt động (Execution Flow)**

Quá trình này chia làm 4 giai đoạn chính: Quản lý nguồn (Nix), Khởi tạo (Initialization), Nạp cấu hình (Loading), và Thực thi (Runtime).

```bash
graph TD  
    subgraph "Giai đoạn 0: Quản lý nguồn (Nix/Home Manager)"  
        S\[File nguồn: \~/nix-config/dotfiles/starship.toml\] \--\>|nix build| NS\[Nix Store: /nix/store/...\]  
        NS \--\>|Symlink| SL\[\~/.config/starship.toml\]  
    end

    subgraph "Giai đoạn 1: env.nu (Môi trường)"  
        A\[Bắt đầu Nushell\] \--\> B\[Đọc file env.nu\]  
        B \--\> C{Lệnh: starship init nu}  
        C \--\> D\[Sinh mã Script Nushell \- Hook\]  
        D \--\> E\[Lưu vào \~/.cache/starship/init.nu\]  
    end

    subgraph "Giai đoạn 2: config.nu (Cấu hình)"  
        E \--\> F\[Đọc file config.nu\]  
        F \--\> G\[Lệnh: source init.nu\]  
        G \--\> H\[Đăng ký các Prompt Hooks\]  
    end

    subgraph "Giai đoạn 3: Runtime (Thực thi)"  
        H \--\> I\[Người dùng gõ lệnh/Enter\]  
        I \--\> J\[Nushell gọi Hook: PROMPT\_COMMAND\]  
        J \--\> K\[Chạy lệnh: starship prompt\]  
        K \--\> L{Binary Starship đọc: \~/.config/starship.toml}  
        L \--\> M\[Quét thư mục: Git, Python, Node...\]  
        M \--\> N\[Hiển thị giao diện màu sắc\]  
    end

```
## **2\. Giải thích chi tiết về nguồn gốc cấu hình (Dotfiles)**

Đây là phần then chốt để hiểu làm thế nào Starship "nhìn thấy" những gì bạn sửa trong thư mục dotfiles:

### **Nguồn gốc thực sự (Source of Truth)**

Khi bạn sửa file tại \~/nix-config/dotfiles/starship.toml, đó là file vật lý duy nhất bạn có quyền chỉnh sửa.

### **Cách Nix kết nối dữ liệu**

1. Khai báo trong Nix: Trong file home.nix, bạn khai báo:  
   xdg.configFile."starship.toml".source \= ./dotfiles/starship.toml;  
2. **Đóng gói (Build):** Khi bạn chạy nix build, Nix copy nội dung file đó vào một địa chỉ "bất biến" trong Nix Store.  
3. **Liên kết (Activation):** Khi switch, Nix tạo một **Symlink** tại \~/.config/starship.toml trỏ thẳng vào file trong Nix Store.

## **3\. Tại sao cần "starship init nu"?**

### **3.1. Hiểu về "eval" và sự khác biệt của Nushell**

Trong các shell truyền thống (Bash, Zsh, Fish), bạn thường thấy lệnh: eval "$(starship init zsh)".

* **eval là gì?** eval (evaluate) là lệnh nhận vào một chuỗi văn bản và yêu cầu shell thực thi chuỗi đó như một câu lệnh thực tế ngay lập tức trong bộ nhớ.  
* **Tại sao Nushell không dùng eval?** \* **Tính cấu trúc:** Nushell là shell có cấu trúc và cần kiểm tra cú pháp (parse) toàn bộ file cấu hình trước khi thực thi. Việc "bơm" mã ngẫu nhiên vào bộ nhớ lúc đang chạy bằng eval có thể gây mất ổn định và khó tối ưu hiệu năng.  
  * **Bảo mật:** eval thường được coi là một kẽ hở bảo mật nếu chuỗi văn bản bị thay đổi ác ý.

### **3.2. Cơ chế "Save & Source"**

Thay vì dùng eval, Nushell sử dụng quy trình an toàn hơn:

1. **Tạo script:** starship init nu sinh ra các đoạn mã Nushell cần thiết (như định nghĩa hàm vẽ prompt).  
2. **Lưu file vật lý:** save \-f init.nu ghi đoạn mã đó thành một file thực trên đĩa.  
3. **Nạp tĩnh:** source init.nu yêu cầu Nushell đọc và kiểm tra cú pháp file đó một cách minh bạch trước khi áp dụng.

### **3.3. Lệnh starship init nu (Cái "Cầu nối" kỹ thuật)**

* **Nhiệm vụ:** Không phải là chuyển đổi nội dung .toml. Nhiệm vụ của nó là sinh ra các **hàm hệ thống** (Hooks) để "dạy" Nushell cách giao tiếp với chương trình Starship.  
* **Nội dung:** Nó tạo ra hàm PROMPT\_COMMAND. Hàm này ra lệnh cho Nushell: *"Mỗi khi người dùng nhấn Enter, hãy chạy chương trình starship prompt và lấy kết quả đó hiển thị lên màn hình"*.  
* **Bản chất:** Đây là mã nguồn shell tĩnh. Nó chỉ đăng ký "hợp đồng thuê họa sĩ" (Starship binary) cho Nushell.

### 3.4 File starship.toml (Cái "Bản thiết kế" giao diện)**

* **Nhiệm vụ:** Chứa các chỉ dẫn về thẩm mỹ (màu sắc, biểu tượng).  
* **Nội dung:** Ví dụ \[directory\] style \= "bold blue".  
* **Cơ chế:** File này **không bao giờ** được biến thành code Nushell. Thay vào đó, nó được chương trình Starship (binary) đọc trực tiếp mỗi khi bạn gõ lệnh.
## **4\. Giải thích chi tiết các bước khởi động**

### **Bước 1: Khởi tạo tại env.nu**

* Lệnh starship init nu đóng vai trò "phiên dịch viên". Nó yêu cầu binary Starship tạo ra các hàm đặc thù dành riêng cho cú pháp của Nushell.  
* Việc lưu vào .cache giúp Nushell không phải tốn tài nguyên chạy lệnh khởi tạo lại từ đầu cho mỗi tab mới.

### **Bước 2: Nạp mã tại config.nu**

* Lệnh source nạp các "Hooks" (điểm chạm).  
* Starship sẽ đăng ký vào các biến hệ thống:  
  * $env.PROMPT\_COMMAND: Hàm vẽ prompt bên trái.  
  * $env.PROMPT\_INDICATOR: Ký hiệu chờ lệnh.

### **Bước 3: Thực thi tại Runtime**

Mỗi khi bạn nhấn **Enter**:

1. Binary starship được gọi.  
2. Nó truy cập \~/.config/starship.toml (thông qua Symlink dẫn tới file dotfiles của bạn).  
3. Xuất ra chuỗi ký tự ANSI màu sắc.

## **5\. Lưu ý quan trọng cho người dùng Nix**

1. **Quên git add:** Nếu bạn sửa dotfiles/starship.toml mà không git add, Nix sẽ build bản cũ trong Store và bạn sẽ thấy cấu hình không thay đổi.  
2. **Thứ tự nạp:** env.nu chuẩn bị "vỏ" (init script), config.nu nạp "ruột" (source script), và Starship binary nạp "linh hồn" (file .toml).

*Tài liệu được biên soạn để hỗ trợ việc quản lý hệ thống macOS qua Nix và Nushell.*
