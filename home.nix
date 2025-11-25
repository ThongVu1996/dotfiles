{ config, pkgs, username, ... }:

{
  home.username = username;
  home.homeDirectory = "/Users/${username}";
  home.stateVersion = "24.05";

  # 1. Cài đặt các phần mềm cần thiết
  home.packages = with pkgs; [
    starship
    ripgrep
    fzf
    eza
    bat
    neovim
    tmux	
  ];

  # 2. LIÊN KẾT CẤU HÌNH TỪ THƯ MỤC 'dot' (QUAN TRỌNG NHẤT)
  # Cú pháp: xdg.configFile."TÊN_TRONG_CONFIG".source = ĐƯỜNG_DẪN_THỰC_TẾ;

  # Neovim: Link ./dot/nvim -> ~/.config/nvim
  xdg.configFile."nvim".source = ./dot/nvim;

  # WezTerm: Link ./dot/wezterm -> ~/.config/wezterm
  xdg.configFile."wezterm".source = ./dot/wezterm;

  # Tmux: Link ./dot/tmux -> ~/.config/tmux
  # (Lưu ý: Tmux của bạn nên load config từ ~/.config/tmux/tmux.conf)
  xdg.configFile."tmux".source = ./dot/tmux;

  # Starship: Link file cấu hình
  # Trường hợp 1: Nếu ./dot/starship là một thư mục chứa starship.toml
  xdg.configFile."starship.toml".source = ./dot/starship/starship.toml;

  # Trường hợp 2: Nếu ./dot/starship CHÍNH LÀ file cấu hình (không phải thư mục)
  # thì dùng dòng này (bỏ comment):
  # xdg.configFile."starship.toml".source = ./dot/starship;

  # 3. Kích hoạt Home Manager
  programs.home-manager.enable = true;

  # 4. Cấu hình biến môi trường (Optional)
  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
