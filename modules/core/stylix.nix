{ pkgs, inputs, lib, ... }: {
  stylix = {
    enable = true;
    autoEnable = false;
    image = ./wallpaper.jpg; # Để ảnh wallpaper tại đây

    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-medium.yaml";
    
    # Fonts đồng bộ toàn hệ thống
    fonts = {
      monospace = {
        package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
        name = "JetBrainsMono Nerd Font";
      };
      sizes.terminal = 15;
    };

    # Chỉ bật target cho WezTerm, tắt các cái khác để tránh lỗi Ribbon
    targets = {
      qt.enable = false;
      neovim.enable = lib.mkForce false;
      wezterm.enable = true;
      tmux.enable = true;
      starship.enable = true;
    };
  };
}