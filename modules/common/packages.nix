{ pkgs, ... }:

{
  # Các phần mềm cài đặt ở cấp hệ thống (System-wide), mọi user đều dùng được
  environment.systemPackages = with pkgs; [
    direnv git mkalias
    btop bat btop
    jq fd ripgrep fzf eza
    docker nodejs_22 keepassxc
    # Nvim
    neovim imagemagick pngpaste tmux wezterm fish starship nushell 
    # Dev Tools / LSP
    lua-language-server 
    vue-language-server 
    tailwindcss-language-server 
    typescript-language-server
    emmet-language-server 
    vscode-langservers-extracted 
    prettierd stylua eslint_d  
    typos-lsp marksman markdown-toc
  ];

  # Font chữ thường nên cài ở cấp hệ thống để các app GUI đều nhận diện được
  fonts.packages = [
    pkgs.jetbrains-mono
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.nerd-fonts.hack
  ];
}