{
  username,
  hostname,
  ...
}: {
  # ================================================================
  # 1. SYSTEM CONFIGURATION (nix-darwin)
  # ================================================================
  imports = [
    ./system.nix # Includes user definitions, shell registration, and macOS defaults
    ./stylix.nix # System-wide theming
    ../../modules/desktop/kanata-system.nix
  ];

  myConfig.desktop.kanata.enable = true;

  # Inherited from specialArgs in flake.nix
  networking.hostName = hostname;

  # Ensure the system recognizes the correct home directory for the user
  users.users.${username}.home = "/Users/${username}";

  # ================================================================
  # 2. USER CONFIGURATION (home-manager)
  # ================================================================
  home-manager.users.${username} = {pkgs, lib, ...}: {
    home = {
      inherit username;
      homeDirectory = "/Users/${username}";
      stateVersion = "24.11";
      enableNixpkgsReleaseCheck = false;
    };

    imports = [
      ../../modules # Auto-loads Neovim, Tmux, Shells, etc.
    ];

    # Feature activation using your Dendritic Pattern
    myConfig = {
      terminal = {
        tmux.enable = true;
        shells.enable = true;
        emulators.enable = true;
      };

      desktop = {
        aerospace.enable = true;
        apps.enable = true;
        jankyborders.enable = true;
        skhd.enable = true;
      };

      editor.neovim.enable = true;

      dev.tools = {
        devops.enable = true;
        cli.enable = true;
        web.enable = true;
        misc.enable = true;
        ai.enable = true;
      };
    };

    # Disable manual generation to prevent warnings and build noise
    manual = {
      json.enable = false;
      html.enable = false;
      manpages.enable = false;
    };

    home.activation.fixmacosAppIcons = lib.hm.dag.entryAfter ["trampolineApps"] ''
      /bin/bash ${../../modules/scripts/macos-app-fixer.sh} ${username}
    '';
  };
}
