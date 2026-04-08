{
  description = "Cross-platform Nix Config with Dendritic Pattern";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    mac-app-util.url = "github:hraban/mac-app-util";
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, mac-app-util, stylix, ... }@inputs:
  let
    username = "thongvu";
    hostname = "MacBook-Pro";
  in
  {
    # 1. macOS Configuration (Shared HM features)
    darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = { inherit self inputs username; };
      modules = [
        stylix.darwinModules.stylix
        # mac-app-util: Auto-generate trampoline apps for Spotlight & Dock
        mac-app-util.darwinModules.default
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.extraSpecialArgs = { inherit inputs username; };
          # Enable Spotlight integration for all HM users
          home-manager.sharedModules = [
            mac-app-util.homeManagerModules.default
            stylix.homeModules.stylix
            { stylix.targets.neovim.enable = nixpkgs.lib.mkDefault false; }
          ];
        }
        # Import the main macOS host configuration
        ./hosts/macos/default.nix
      ];
    };

    # 2. Linux Configuration (Standalone Home Manager)
    homeConfigurations."linux" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages."x86_64-linux";
      extraSpecialArgs = { inherit inputs username; };
      modules = [ 
        stylix.homeModules.stylix
        # Import the Linux host configuration (loads exactly the same HM features as macOS)
        ./hosts/linux/default.nix 
      ];
    };
  };
}