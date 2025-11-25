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
   xdg.configFile."starship.toml".source = ./dotfiles/starship/.config/starship.toml;
   xdg.configFile."lazygit/config.yml".source = ./dotfiles/lazygit/.config/lazygit/config.yml;
   xdg.configFile."nvim".source = ./dotfiles/nvim/.config/nvim;
   xdg.configFile."fish/config.fish".source = ./dotfiles/fish/.config/fish/config.fish;
   xdg.configFile."wezterm".source = ./dotfiles/wezterm/.config/wezterm;
   home.file.".tmux.conf".source = ./dotfiles/tmux/.tmux.conf;


  # 3. Kích hoạt Home Manager
  programs.home-manager.enable = true;

  # 4. Cấu hình biến môi trường (Optional)
  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
