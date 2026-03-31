{ config, pkgs, username, lib, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
in
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

  # Activation Script: Fix Spotlight cho Nix Apps
  system.activationScripts.applications.text =
    let 
      env = pkgs.buildEnv {
        name = "system-applications";
        paths = config.environment.systemPackages ++ [ config.home-manager.users.${username}.home.path ];
        pathsToLink = ["/Applications"];
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
