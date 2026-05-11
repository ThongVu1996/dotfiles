{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.myConfig.desktop.zathura;
in {
  options.myConfig.desktop.zathura = {
    enable = lib.mkEnableOption "Enable Zathura PDF viewer";
  };

  config = lib.mkIf cfg.enable {
    programs.zathura = {
      enable = true;
      options = {
        selection-clipboard = "clipboard";
        guioptions = ""; # Ẩn thanh trạng thái, thanh cuộn và dòng lệnh
        window-title-basename = true; # Rút gọn tiêu đề cửa sổ
        # Không cần định nghĩa màu ở đây nữa, Stylix sẽ tự inject vào
      };
    };
  };
}

