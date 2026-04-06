{ config, pkgs, username, lib, ... }:

{
  # Disable nix-darwin's nix-daemon management to let Determinate Systems handle it
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

  # Install essential fonts at the macOS system level
  fonts.packages = [
    pkgs.jetbrains-mono
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.nerd-fonts.hack
  ];

  # Spotlight & Dock: Handled automatically by mac-app-util (flake input)
  # No need for manual activationScripts anymore
    
  system.stateVersion = 5; 
}

