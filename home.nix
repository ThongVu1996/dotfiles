{ config, pkgs, lib, username, ... }:

let 
  nushellConfigPath = "${config.home.homeDirectory}/nix-config/dotfiles/nushell/.config/nushell";
  isDarwin = pkgs.stdenv.isDarwin;
in
{
  programs.home-manager.enable = true;
  home.stateVersion = "24.11";
  home.username = username;
  home.homeDirectory = "/Users/${username}";
  home.enableNixpkgsReleaseCheck = false;
  xdg.enable = true;

  # --- HOME PACKAGES (Chỉ riêng user này dùng) ---
  home.packages = with pkgs; [
    # Code php
    php82 php82Packages.composer php82Packages.php-codesniffer
    # ai
    claude-code
    # CI-CD
    tailscale awscli2 eksctl kubectl 
    kubernetes-helm argocd cloud-nuke 
    terraform python315 pkg-config 
    terraform-ls tflint gh 
  ] 
  ++ lib.optionals isDarwin [
    # macOS Specific Packages
    rio chafa luajit luajitPackages.luarocks 
    luajitPackages.magick opencode switchaudio-osx
  ];

  # --- SYMLINKS CONFIGS ---
  home.file.".tmux.conf".source = ./dotfiles/tmux/.tmux.conf;
  
  xdg.configFile = {
    "starship.toml".source = ./dotfiles/starship/.config/starship.toml;
    
    # Out of store symlinks (Editable configs)
    "nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/dotfiles/nvim/.config/nvim";
    "wezterm".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/dotfiles/wezterm/.config/wezterm";
    "fish/config.fish".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/dotfiles/fish/.config/fish/config.fish";
    "fish/functions".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/dotfiles/fish/.config/fish/functions";
    
    # Chỉ symlink Aerospace và Rio nếu đang dùng macOS
    "aerospace/aerospace.toml".source = lib.mkIf isDarwin (config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/dotfiles/aerospace/.config/aerospace/aerospace.toml");
    "rio/config.toml".source = lib.mkIf isDarwin (config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/dotfiles/rio/.config/rio/config.toml");

    # Nushell Configs
    "nushell/config.nu".source = config.lib.file.mkOutOfStoreSymlink "${nushellConfigPath}/config.nu";
    "nushell/env.nu".source    = config.lib.file.mkOutOfStoreSymlink "${nushellConfigPath}/env.nu";
    "nushell/systems".source   = config.lib.file.mkOutOfStoreSymlink "${nushellConfigPath}/systems";
    "nushell/utils".source     = config.lib.file.mkOutOfStoreSymlink "${nushellConfigPath}/utils";
  };

  # OpenCode Config (JSON in Nix Store)
  xdg.configFile."opencode/opencode.json".text = builtins.toJSON {
    "$schema" = "https://opencode.ai/config.json";
    plugin = [ "opencode-antigravity-auth@latest" ];
    provider = {
      google = { models = { "antigravity-gemini-3-pro" = { name = "Gemini 3 Pro"; }; }; };
    };
  };

  # ENVIRONMENT VARIABLES
  home.sessionVariables = {
    EDITOR = "nvim";
    PKG_CONFIG_PATH = lib.mkIf isDarwin "${pkgs.imagemagick.dev}/lib/pkgconfig";
  };
  
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}