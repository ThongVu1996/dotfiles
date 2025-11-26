{
  description = "Cấu hình hệ thống macOS với nix-darwin";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, darwin, home-manager, ... }:
  let
    system = "aarch64-darwin";
    username = "thongvu";
    hostname = "MacBook-Pro";
  in
  {
    darwinConfigurations."${hostname}" = darwin.lib.darwinSystem {
      inherit system;
      specialArgs = { inherit username; };

      modules = [
        ({ pkgs, config, ... }: {
          
          # User Setup
          users.users."${username}" = {
            home = "/Users/${username}";
            description = username;
            shell = pkgs.fish;
          };
	  nix.enable = false;
          programs.fish.enable = true;
          environment.shells = [ pkgs.fish ];
          
          nixpkgs.config.allowUnfree = true;
	  system.primaryUser = username;
          # system.primaryUser = username; # Dòng này gây lỗi nếu không có module custom, đã comment lại.
          nix.settings.trusted-users = [ "root" username ];
          
          # Fonts
          fonts.packages = [
            pkgs.jetbrains-mono
            pkgs.nerd-fonts.jetbrains-mono
          ];

          # System Packages
          environment.systemPackages = with pkgs; [
            vim
            git
            neofetch
            mkalias
            docker
            lazydocker
            lazygit
            # Apps GUI
            wezterm
            vscode
            aerospace
            fish
          ];

          # MacOS Defaults
          system.defaults = {
            dock.autohide = true;
            finder.AppleShowAllExtensions = true;
            NSGlobalDomain.AppleInterfaceStyle = "Dark";
          };

          # Activation Script (Fix Spotlight)
          system.activationScripts.applications.text = let
            env = pkgs.buildEnv {
              name = "system-applications";
              paths = config.environment.systemPackages;
              pathsToLink = [ "/Applications" ];
            };
          in
            pkgs.lib.mkForce ''
            # Set up /Applications/Nix Apps
            echo "Setting up /Applications/Nix Apps..." >&2
            rm -rf /Applications/Nix\ Apps
            mkdir -p /Applications/Nix\ Apps
            find ${env}/Applications -maxdepth 1 -type l -exec readlink -f '{}' \; |
            while read -r src; do
              app_name=$(basename "$src")
              echo "Copying shortcut for $src" >&2
              ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
            done
          '';

          nix.settings.experimental-features = "nix-command flakes";
          system.stateVersion = 5;
        })

        # Home Manager Module
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit username; };
          home-manager.users."${username}" = import ./home.nix;
          home-manager.backupFileExtension = "backup";
        }
      ];
    };
  };
}
