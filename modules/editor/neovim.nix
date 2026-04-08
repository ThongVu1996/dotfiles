{ config, pkgs, lib, ... }:

let
  cfg = config.myConfig.editor.neovim;
  # Đường dẫn tới thư mục nvim trong dotfiles của bạn
  dotfilesPath = config.myConfig.dotfilesPath;
in
{
  options.myConfig.editor.neovim = {
    enable = lib.mkEnableOption "Enable Neovim configuration and LSPs";
  };

  config = lib.mkIf cfg.enable {
    # 1. Tắt Stylix cho Neovim để tránh việc Stylix tự tạo file init.lua trong nix-store
    # gây xung đột với Symlink thư mục của bạn.
    stylix.targets.neovim.enable = lib.mkForce false;

    programs.neovim = {
      enable = true;
      withRuby = false;
      withPython3 = true; # Khuyên dùng true nếu bạn có dùng các plugin cần python
      withNodeJs = true;
      plugins = [
        pkgs.vimPlugins.base16-nvim
      ];
    };

    home.packages = with pkgs; [
      # Theme engine để bạn có thể gọi colorscheme trong init.lua thật
      vimPlugins.base16-nvim

      # --- LSPs & Tooling ---
      # Web & Modern Scripting
      lua-language-server
      stylua
      vue-language-server 
      tailwindcss-language-server 
      vtsls
      emmet-language-server 
      vscode-langservers-extracted 
      
      # Formatters & Linters
      prettierd
      eslint_d  
      cspell 
      
      # PHP Environment
      intelephense 
      
      # Markdown & Docs
      markdown-toc
      markdown-oxide
      yaml-language-server

      # Extra tools thường dùng cho Neovim
      ripgrep
      fd
    ];

    home.sessionVariables = {
      EDITOR = "nvim";
    };

    xdg.configFile."nvim-stylix-config.lua".text = ''
      -- Lấy slug an toàn từ Stylix
      vim.g.stylix_theme = "base16-${config.lib.stylix.colors.scheme or "gruvbox-material-dark-medium"}"
      vim.g.base16_plugin_path = "${pkgs.vimPlugins.base16-nvim}"
    '';

    # 2. SYMLINK QUẢN LÝ CHÍNH
    # Link toàn bộ thư mục nvim từ dotfiles vào ~/.config/nvim
    # Sử dụng mkOutOfStoreSymlink giúp bạn sửa file trong dotfiles là Neovim ăn ngay không cần rebuild
    xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/nvim/.config/nvim";
  };
}