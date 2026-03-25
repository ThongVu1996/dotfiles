{ config, pkgs, username, ... }:

{
  # Quản lý nix-daemon bằng nix-darwin
  nix.enable = true; 
  nix.settings.experimental-features = "nix-command flakes";
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };

  # Homebrew (Chỉ có trên macOS)
  homebrew = {
    enable = true;
    casks = [ "sf-symbols" "font-sf-pro" ];
    onActivation.autoUpdate = true;
  };

  # macOS System Defaults
  system.defaults = {
    dock.autohide = true;
    finder.AppleShowAllExtensions = true;
    NSGlobalDomain.AppleInterfaceStyle = "Dark";
  };
  
  services.tailscale.enable = true;

  # Activation Script: Fix Spotlight cho cả Nix Apps và Home Manager Apps
  system.activationScripts.applications.text =
    let 
      env = pkgs.buildEnv {
        name = "system-applications";
        # Kết hợp app từ systemPackages và app từ home-manager
        paths = config.environment.systemPackages ++ [ config.home-manager.users.${username}.home.path ];
        pathsToLink = "/Applications";
      };
    in pkgs.lib.mkForce ''
      echo "Setting up /Applications/Nix Apps..." >&2
      rm -rf /Applications/Nix\ Apps
      mkdir -p /Applications/Nix\ Apps
      find ${env}/Applications -maxdepth 1 -type l -exec readlink -f '{}' \; \
        | while read -r src; do
            app_name=$(basename "$src")
            echo "Copying shortcut for $src" >&2
            ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
          done
    '';
    
  system.stateVersion = 5; 
}