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
      plugins = with pkgs.vimPlugins; [
        base16-nvim
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
      vtsls
      tailwindcss-language-server
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

      -- Tiếp tục xuất bảng màu để Neovim dùng trong Lua
      vim.g.base16_colors = {
        base00 = "#${config.lib.stylix.colors.base00}",
        base01 = "#${config.lib.stylix.colors.base01}",
        base02 = "#${config.lib.stylix.colors.base02}",
        base03 = "#${config.lib.stylix.colors.base03}",
        base04 = "#${config.lib.stylix.colors.base04}",
        base05 = "#${config.lib.stylix.colors.base05}",
        base06 = "#${config.lib.stylix.colors.base06}",
        base07 = "#${config.lib.stylix.colors.base07}",
        base08 = "#${config.lib.stylix.colors.base08}",
        base09 = "#${config.lib.stylix.colors.base09}",
        base0A = "#${config.lib.stylix.colors.base0A}",
        base0B = "#${config.lib.stylix.colors.base0B}",
        base0C = "#${config.lib.stylix.colors.base0C}",
        base0D = "#${config.lib.stylix.colors.base0D}",
        base0E = "#${config.lib.stylix.colors.base0E}",
        base0F = "#${config.lib.stylix.colors.base0F}",
      }
    '';

    # 2. SYMLINK QUẢN LÝ CHÍNH
    # Link toàn bộ thư mục nvim từ dotfiles vào ~/.config/nvim
    # Sử dụng mkOutOfStoreSymlink giúp bạn sửa file trong dotfiles là Neovim ăn ngay không cần rebuild
    xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/nvim/.config/nvim";
  };
}