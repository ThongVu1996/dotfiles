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
   xdg.configFile."starship.toml".source = ./dot/starship/.config/starship.toml;
   xdg.configFile."lazygit/config.yml".source = ./dot/lazygit/.config/lazygit/config.yml;
   xdg.configFile."fish/config.fish".source = ./dot/fish/.config/fish/config.fish;
   xdg.configFile."wezterm".source = ./dot/wezterm/.config/wezterm;
   home.file.".tmux.conf".source = ./dot/tmux/.tmux.conf;


  # 3. Kích hoạt Home Manager
  programs.home-manager.enable = true;

  # 4. Cấu hình biến môi trường (Optional)
  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
