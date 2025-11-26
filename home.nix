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
    stats
    hidden-bar
  ];

  # 2. LIÊN KẾT CẤU HÌNH TỪ THƯ MỤC 'dot' (QUAN TRỌNG NHẤT)
  # Cú pháp: xdg.configFile."TÊN_TRONG_CONFIG".source = ĐƯỜNG_DẪN_THỰC_TẾ;
   xdg.configFile."starship.toml".source = ./dotfiles/starship/.config/starship.toml;
   xdg.configFile."lazygit/config.yml".source = ./dotfiles/lazygit/.config/lazygit/config.yml;
   # xdg.configFile."nvim".source = ./dotfiles/nvim/.config/nvim;
   # xdg.configFile."wezterm".source = ./dotfiles/wezterm/.config/wezterm;
    # xdg.configFile."fish/config.fish".source = ./dotfiles/fish/.config/fish/config.fish;
    # xdg.configFile."aerospace/aerospace.toml".source = ./dotfiles/aerospace/.config/aerospace/aerospace.toml;
   home.file.".tmux.conf".source = ./dotfiles/tmux/.tmux.conf;

   # 1. Neovim (Dùng mkOutOfStoreSymlink để sửa là ăn ngay)
  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "/Users/${username}/nix-config/dotfiles/nvim/.config/nvim";

  # 2. WezTerm (Tương tự)
  xdg.configFile."wezterm".source = config.lib.file.mkOutOfStoreSymlink "/Users/${username}/nix-config/dotfiles/wezterm/.config/wezterm";

   xdg.configFile."fish/config.fish".source = config.lib.file.mkOutOfStoreSymlink "/Users/${username}/nix-config/dotfiles/fish/.config/fish/config.fish";
   xdg.configFile."aerospace/aerospace.toml".source = config.lib.file.mkOutOfStoreSymlink "/Users/${username}/nix-config/dotfiles/aerospace/.config/aerospace/aerospace.toml";
  # 3. Kích hoạt Home Manager
  programs.home-manager.enable = true;

  # 4. Cấu hình biến môi trường (Optional)
  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
