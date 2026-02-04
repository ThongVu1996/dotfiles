{ config, pkgs, lib, username, ... }:

let 
  nushellConfigPath = "${config.home.homeDirectory}/nix-config/dotfiles/nushell/.config/nushell";
  macismPkg = import ./macism.nix { inherit pkgs; };
in
{
  programs.home-manager.enable = true;
  home.stateVersion = "24.05";
  home.username = username;
  home.homeDirectory = "/Users/${username}";
  home.enableNixpkgsReleaseCheck = false;
  xdg.enable = true;
  imports = [

  ];
  
  # Home Packages
  home.packages = with pkgs; [
    starship ripgrep fzf eza bat neovim tmux hidden-bar
    nodejs_22 tailscale awscli2 eksctl kubectl fd 
    aerospace kubernetes-helm wireshark imagemagick pngpaste
    intelephense phpactor
    lua-language-server 
    vue-language-server tailwindcss-language-server typescript-language-server
    emmet-language-server vscode-langservers-extracted 
    prettierd stylua eslint_d php82Packages.php-codesniffer 
    typos-lsp
    marksman
    markdown-toc
    nushell
    direnv
    argocd
    php82
    php82Packages.composer
    cloud-nuke
    terraform
    keepassxc
    claude-code
    python315
    neovim
    pkg-config
    terraform-ls
    tflint

    rio
    chafa
    luajit
    luajitPackages.luarocks
    luajitPackages.magick
    opencode
    sketchybar-app-font
    sketchybar
    gh
    switchaudio-osx
  (writeShellScriptBin "opencode-zsh" ''
    #!/bin/sh
    export SHELL="/run/current-system/sw/bin/zsh"
    export TERMINAL="zsh"
    exec opencode "$@"
  '')
  ]
  ++ lib.optionals pkgs.stdenv.isDarwin [
    macismPkg
  ];

  # Symlinks configs (Tạo 1 symlinks từ thư mục ~/.config/ten-phan-mem tới 1 folder chứa config trong nixstore)
  # Nội dung trong nix store sẽ được lấy từ dotfiles và readonly
  # Chỉ có thể thay đổi khi thay đổi dotfiles và rebuild lại 
  home.file.".tmux.conf".source = ./dotfiles/tmux/.tmux.conf;
  xdg.configFile."starship.toml".source = ./dotfiles/starship/.config/starship.toml;
  # xdg.configFile."nushell/config.nu".source = ./dotfiles/nushell/.config/nushell/config.nu;
  # xdg.configFile."nushell/env.nu".source = ./dotfiles/nushell/.config/nushell/env.nu;
  # xdg.configFile."nushell/systems".source = ./dotfiles/nushell/.config/nushell/systems;
  # xdg.configFile."nushell/utils".source = ./dotfiles/nushell/.config/nushell/utils;
  # Out of store symlinks (Editable configs)
  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/dotfiles/nvim/.config/nvim";
  xdg.configFile."wezterm".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/dotfiles/wezterm/.config/wezterm";
  xdg.configFile."fish/config.fish".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/dotfiles/fish/.config/fish/config.fish";
  xdg.configFile."fish/functions".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/dotfiles/fish/.config/fish/functions";
  xdg.configFile."aerospace/aerospace.toml".source = config.lib.file.mkOutOfStoreSymlink "/Users/${username}/nix-config/dotfiles/aerospace/.config/aerospace/aerospace.toml";
  xdg.configFile = {
    "nushell/config.nu".source = config.lib.file.mkOutOfStoreSymlink "${nushellConfigPath}/config.nu";
    "nushell/env.nu".source    = config.lib.file.mkOutOfStoreSymlink "${nushellConfigPath}/env.nu";
    
    # Nếu 'systems' và 'utils' là thư mục, nó sẽ symlink cả thư mục (rất tiện)
    "nushell/systems".source   = config.lib.file.mkOutOfStoreSymlink "${nushellConfigPath}/systems";
    "nushell/utils".source     = config.lib.file.mkOutOfStoreSymlink "${nushellConfigPath}/utils";
  };
  xdg.configFile."rio/config.toml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/dotfiles/rio/.config/rio/config.toml";

xdg.configFile."opencode/opencode.json".text = builtins.toJSON {
  "$schema" = "https://opencode.ai/config.json";
  plugin = [ "opencode-antigravity-auth@latest" ];
  # shell = {
  #   path = "${pkgs.zsh}/bin/zsh";
  #   args = [ "-l" ];
  # };
  provider = {
    google = {
      models = {
        "antigravity-gemini-3-pro" = {
          name = "Gemini 3 Pro (Antigravity)";
          limit = { context = 1048576; output = 65535; };
          modalities = { input = [ "text" "image" "pdf" ]; output = [ "text" ]; };
          variants = {
            low = { thinkingLevel = "low"; };
            high = { thinkingLevel = "high"; };
          };
        };
        "antigravity-gemini-3-flash" = {
          name = "Gemini 3 Flash (Antigravity)";
          limit = { context = 1048576; output = 65536; };
          modalities = { input = [ "text" "image" "pdf" ]; output = [ "text" ]; };
          variants = {
            minimal = { thinkingLevel = "minimal"; };
            low = { thinkingLevel = "low"; };
            medium = { thinkingLevel = "medium"; };
            high = { thinkingLevel = "high"; };
          };
        };
        "antigravity-claude-sonnet-4-5" = {
          name = "Claude Sonnet 4.5 (Antigravity)";
          limit = { context = 200000; output = 64000; };
          modalities = { input = [ "text" "image" "pdf" ]; output = [ "text" ]; };
        };
        "antigravity-claude-sonnet-4-5-thinking" = {
          name = "Claude Sonnet 4.5 Thinking (Antigravity)";
          limit = { context = 200000; output = 64000; };
          modalities = { input = [ "text" "image" "pdf" ]; output = [ "text" ]; };
          variants = {
            low = { thinkingConfig = { thinkingBudget = 8192; }; };
            max = { thinkingConfig = { thinkingBudget = 32768; }; };
          };
        };
        "antigravity-claude-opus-4-5-thinking" = {
          name = "Claude Opus 4.5 Thinking (Antigravity)";
          limit = { context = 200000; output = 64000; };
          modalities = { input = [ "text" "image" "pdf" ]; output = [ "text" ]; };
          variants = {
            low = { thinkingConfig = { thinkingBudget = 8192; }; };
            max = { thinkingConfig = { thinkingBudget = 32768; }; };
          };
        };
        "gemini-2.5-flash" = {
          name = "Gemini 2.5 Flash (Gemini CLI)";
          limit = { context = 1048576; output = 65536; };
          modalities = { input = [ "text" "image" "pdf" ]; output = [ "text" ]; };
        };
        "gemini-2.5-pro" = {
          name = "Gemini 2.5 Pro (Gemini CLI)";
          limit = { context = 1048576; output = 65536; };
          modalities = { input = [ "text" "image" "pdf" ]; output = [ "text" ]; };
        };
        "gemini-3-flash-preview" = {
          name = "Gemini 3 Flash Preview (Gemini CLI)";
          limit = { context = 1048576; output = 65536; };
          modalities = { input = [ "text" "image" "pdf" ]; output = [ "text" ]; };
        };
        "gemini-3-pro-preview" = {
          name = "Gemini 3 Pro Preview (Gemini CLI)";
          limit = { context = 1048576; output = 65535; };
          modalities = { input = [ "text" "image" "pdf" ]; output = [ "text" ]; };
        };
      };
    };
  };
};
  # Environment Variables
  home.sessionVariables = {
    EDITOR = "nvim";
    PKG_CONFIG_PATH = "${pkgs.imagemagick.dev}/lib/pkgconfig";
  };
  
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  
  xdg.configFile."sketchybar" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/dotfiles/sketchybar/.config/sketchybar";
    recursive = true;
  };
}
