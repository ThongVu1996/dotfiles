{ pkgs, config, lib, username, ... }:

{
  # 1. Cấu hình Stylix cấp HỆ THỐNG (Giữ nguyên ở ngoài)
  stylix = {
    enable = true;
    autoEnable = false;
    image = ../../modules/core/wallpaper.jpg; 
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-soft.yaml";

    fonts = {
      monospace = {
        package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
        name = "JetBrainsMono Nerd Font";
      };
      sizes.terminal = 15;
    };
  };

  # 2. Cấu hình cấp USER (Home Manager)
  home-manager.users."${username}" = {
    
    # PHẦN 1: ĐỊNH NGHĨA (OPTIONS) - Để ở ngoài cùng của block user
    options.qt.qt5ctSettings = lib.mkOption {
      type = lib.types.attrsOf (lib.types.attrsOf lib.types.anything);
      default = {};
      internal = true;
    };
    options.qt.qt6ctSettings = lib.mkOption {
      type = lib.types.attrsOf (lib.types.attrsOf lib.types.anything);
      default = {};
      internal = true;
    };

    # PHẦN 2: SỬ DỤNG (CONFIG) - Bắt buộc phải bọc trong 'config' 
    # vì file này đã có phần 'options' ở trên.
    config = {
      stylix.targets = {
        tmux.enable = true;
        starship.enable = true;
        wezterm.enable = true;
      };
    };
  };
}