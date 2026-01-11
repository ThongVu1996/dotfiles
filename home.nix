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
    terraform-ls
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

  # Environment Variables
  home.sessionVariables = {
    EDITOR = "nvim";
  };
  
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
