{ config, pkgs, username, lib, ... }:

{
  # ================================================================
  # 1. CẤU HÌNH HỆ THỐNG (nix-darwin)
  # ================================================================
  imports = [
    ./system.nix
    ./stylix.nix
  ];

  networking.hostName = "MacBook-Pro";

  # ÉP HỆ THỐNG NHẬN DIỆN ĐÚNG HOME CHO USER
  users.users.${username}.home = "/Users/${username}";

  # ================================================================
  # 2. CẤU HÌNH NGƯỜI DÙNG (home-manager)
  # ================================================================
  home-manager.users.${username} = { pkgs, config, lib, ... }: {
    
    # ĐỊNH NGHĨA "VÙNG AN TOÀN" CHO HOME MANAGER
    home = {
      username = username;
      homeDirectory = lib.mkForce "/Users/thongvu"; # Cực kỳ quan trọng để fix lỗi 'outside $HOME'
      stateVersion = "24.11";
      enableNixpkgsReleaseCheck = false;
    };

    imports = [
      ../../modules   # Tự động nạp Neovim, Tmux, Shells, v.v.
    ];

    # Kích hoạt các tính năng theo cấu trúc Dendritic Pattern của bạn
    myConfig = {
      terminal.tmux.enable = true;
      terminal.shells.enable = true;
      terminal.emulators.enable = true;
      desktop.aerospace.enable = true;
      desktop.apps.enable = true;
      editor.neovim.enable = true;
      
      # Dev Environment
      dev.tools.devops.enable = true;
      dev.tools.cli.enable = true;
      dev.tools.web.enable = true;
      dev.tools.misc.enable = true;
      dev.tools.ai.enable = true;
    };

    # Tắt build các file manual để tránh warning và lỗi vặt
    manual = {
      json.enable = false;
      html.enable = false;
      manpages.enable = false;
    };
  };
}