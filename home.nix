{ config, pkgs, lib, username, ... }:

let 
  macismPkg = import ./macism.nix { inherit pkgs; };
in
{
  programs.home-manager.enable = true;
  home.stateVersion = "24.05";
  home.username = username;
  home.homeDirectory = "/Users/${username}";
  home.enableNixpkgsReleaseCheck = false;
  xdg.enable = true;
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
  ]
  ++ lib.optionals pkgs.stdenv.isDarwin [
    macismPkg
  ];

  # Symlinks configs
  home.file.".tmux.conf".source = ./dotfiles/tmux/.tmux.conf;
  xdg.configFile."starship.toml".source = ./dotfiles/starship/.config/starship.toml;
  
  # Out of store symlinks (Editable configs)
  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/dotfiles/nvim/.config/nvim";
  xdg.configFile."wezterm".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/dotfiles/wezterm/.config/wezterm";
  xdg.configFile."fish/config.fish".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/dotfiles/fish/.config/fish/config.fish";
  xdg.configFile."fish/functions".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/dotfiles/fish/.config/fish/functions";
  xdg.configFile."aerospace/aerospace.toml".source = config.lib.file.mkOutOfStoreSymlink "/Users/${username}/nix-config/dotfiles/aerospace/.config/aerospace/aerospace.toml";

  # Environment Variables
  home.sessionVariables = {
    EDITOR = "nvim";
  };
  
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
