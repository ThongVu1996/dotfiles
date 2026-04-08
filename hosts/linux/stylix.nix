{ pkgs, config, lib, ... }:

{
  stylix = {
    enable = true;
    autoEnable = false;
    
    # Nhớ kiểm tra lại đường dẫn ảnh cho đúng với vị trí file này nhé
    image = ../../modules/core/wallpaper.jpg; 
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-medium.yaml";

    fonts = {
      monospace = {
        package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
        name = "JetBrainsMono Nerd Font";
      };
      sizes.terminal = 15;
    };

    # GOM TẤT CẢ TARGETS VÀO ĐÂY (Vì không có sự phân biệt hệ thống/user nữa)
    targets = {
      tmux.enable = true;
      starship.enable = true;
      wezterm.enable = true;
    };
  };
}