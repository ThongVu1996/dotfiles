{ config, pkgs,username, ... }:

{
  # Tắt nix-daemon vì nix-darwin sẽ quản lý (tùy chọn, thường là enable = false nếu cài Lix hoặc DeterminateSystems)
  nix.enable = false; 
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };

  system.primaryUser = username;

  # System Packages
  environment.systemPackages = with pkgs; [
    vim git neofetch mkalias docker lazydocker lazygit delta btop
    wezterm fish jq
    lua5_4
    luarocks

    lua54Packages.lua-cjson

  ];

  # Fonts
  fonts.packages = [
    pkgs.jetbrains-mono
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.nerd-fonts.hack
  ];

  homebrew = {
    enable = true; # Bắt buộc phải có dòng này để nix-darwin quản lý Homebrew
    casks = [
      "sf-symbols"
      "font-sf-pro"
    ];
    # Tùy chọn: Tự động cập nhật Homebrew khi rebuild
    onActivation.autoUpdate = true;
    # Tùy chọn: Tự động dọn dẹp các app không có trong list (cẩn thận khi dùng)
    # onActivation.cleanup = "zap"; 
  };

  # macOS System Defaults
  system.defaults = {
    dock.autohide = true;
    finder.AppleShowAllExtensions = true;
    NSGlobalDomain.AppleInterfaceStyle = "Dark";
  };



  # Activation Script: Fix Spotlight cho Nix Apps
  system.activationScripts.applications.text =
    let env = pkgs.buildEnv {
      name = "system-applications";
      paths = config.environment.systemPackages;
      pathsToLink = [ "/Applications" ];
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
