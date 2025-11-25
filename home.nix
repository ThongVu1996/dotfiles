{ config, pkgs, ... }:

{
  # Thông tin người dùng
  home.username = "thongvu";
  home.homeDirectory = "/Users/thongvu";

  # Quản lý phiên bản state (giữ nguyên, không nên đổi thường xuyên)
  home.stateVersion = "24.05";

  # --- CÀI ĐẶT PHẦN MỀM USER ---
  home.packages = with pkgs; [
    # Các công cụ CLI
    fzf       # Tìm kiếm mờ (Fuzzy finder)
    ripgrep   # Tìm kiếm trong file siêu nhanh (thay thế grep)
    eza       # Liệt kê file đẹp hơn (thay thế ls)
    tree      # Xem cây thư mục
    
    # Bạn có thể thêm các app khác tại đây:
    starship # Prompt đẹp cho terminal
    bat      # Xem nội dung file (cat clone) có màu
    fish
  ];

  # Ví dụ cấu hình biến môi trường (Optional)
  home.sessionVariables = {
    EDITOR = "vim";
  };

  # Bắt buộc: Để Home Manager tự quản lý chính nó
  programs.home-manager.enable = true;
}
