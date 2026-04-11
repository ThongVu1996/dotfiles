{
  pkgs,
  username,
  ...
}: {
  # ================================================================
  # 1. NIX DAEMON MANAGEMENT
  # ================================================================
  # Disabled to let Determinate Systems manage the Nix installer & daemon.
  # This prevents conflicts between nix-darwin and the DetSys installer.
  nix.enable = false;

  # ================================================================
  # 2. SHELL & USER REGISTRATION
  # ================================================================
  # Register Fish as a valid login shell in /etc/shells
  programs.fish.enable = true;

  # Define the system-level user account
  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
    shell = pkgs.fish;
  };

  # ================================================================
  # 3. MACOS SYSTEM CONFIGURATION
  # ================================================================
  system = {
    # Define the primary user for macOS user privileges
    primaryUser = username;

    # Do not change this unless you have read the release notes.
    stateVersion = 5;

    defaults = {
      # Dock settings
      dock = {
        autohide = true;
        mru-spaces = false; # Prevent spaces from reordering based on use
        show-recents = false; # Keep the dock clean
      };

      # Finder settings
      finder = {
        AppleShowAllExtensions = true;
        _FXShowPosixPathInTitle = true; # Show full path in Finder title bar
        FXEnableExtensionChangeWarning = false; # Disable warning when changing extensions
      };

      # Global macOS settings
      NSGlobalDomain = {
        AppleInterfaceStyle = "Dark";
        AppleShowAllExtensions = true;
        "com.apple.mouse.tapBehavior" = 1; # Enable tap-to-click
      };
    };
  };

  # ================================================================
  # 4. SYSTEM SERVICES & FONTS
  # ================================================================
  services.tailscale.enable = true;

  fonts.packages = with pkgs; [
    jetbrains-mono
    nerd-fonts.jetbrains-mono
    nerd-fonts.hack
  ];
}
