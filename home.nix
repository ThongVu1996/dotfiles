{ config, pkgs, lib, username, ... }:

{
  programs.home-manager.enable = true;
  home.stateVersion = "24.05";
  home.username = username;
  home.homeDirectory = "/Users/${username}";
  home.enableNixpkgsReleaseCheck = false;
  xdg.enable = true;

  # Import module aerospace tách riêng
  imports = [
    ./aerospace.nix
  ];

  # Home Packages
  home.packages = with pkgs; [
    starship ripgrep fzf eza bat neovim tmux stats hidden-bar
    nodejs_22 tailscale awscli2 eksctl kubectl fd 
    # aerospace # Không cần cài ở đây nữa vì programs.aerospace.enable = true sẽ tự cài
  ];

  # Symlinks configs
  home.file.".tmux.conf".source = ./dotfiles/tmux/.tmux.conf;
  xdg.configFile."starship.toml".source = ./dotfiles/starship/.config/starship.toml;
  
  # Out of store symlinks (Editable configs)
  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/dotfiles/nvim/.config/nvim";
  xdg.configFile."wezterm".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/dotfiles/wezterm/.config/wezterm";
  xdg.configFile."fish/config.fish".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/dotfiles/fish/.config/fish/config.fish";
  xdg.configFile."fish/functions".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/dotfiles/fish/.config/fish/functions";

  # Environment Variables
  home.sessionVariables = {
    EDITOR = "nvim";
  };
  
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
