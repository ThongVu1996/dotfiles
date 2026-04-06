{ config, pkgs, username, lib, ... }:

{
  # Tắt quản lý nix-daemon của nix-darwin để nhường quyền cho Determinate Systems
  nix.enable = false; 
  nix.settings.experimental-features = "nix-command flakes";
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };

  system.primaryUser = username;

  # macOS System Defaults
  system.defaults = {
    dock.autohide = true;
    finder.AppleShowAllExtensions = true;
    NSGlobalDomain.AppleInterfaceStyle = "Dark";
  };
  
  services.tailscale.enable = true;

  # Cài một số font cần thiết ở cấp độ hệ thống macOS
  fonts.packages = [
    pkgs.jetbrains-mono
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.nerd-fonts.hack
  ];

  # Spotlight & Dock: Được xử lý tự động bởi mac-app-util (flake input)
  # Không cần activationScripts thủ công nữa
    
  system.stateVersion = 5; 
}

