{
  description = "Cross-platform Nix Config with Dendritic Pattern";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, mac-app-util, ... }@inputs:
  let
    username = "thongvu";
    hostname = "MacBook-Pro";
  in
  {
    # 1. Cấu hình cho macOS (Dùng chung tính năng HM)
    darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = { inherit self inputs username; };
      modules = [
        # mac-app-util: Tự động tạo trampoline apps cho Spotlight & Dock
        mac-app-util.darwinModules.default
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs username; };
          # Cho phép tất cả HM users cũng được hưởng Spotlight integration
          home-manager.sharedModules = [
            mac-app-util.homeManagerModules.default
          ];
        }
        # Gọi file thiết lập chính của máy mác vào
        ./hosts/macos/default.nix
      ];
    };

    # 2. Cấu hình dự phòng cho Linux (Standalone Home Manager)
    homeConfigurations."linux" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages."x86_64-linux";
      extraSpecialArgs = { inherit inputs username; };
      modules = [ 
        # Gọi trực tiếp file linux vào (hoàn toàn tải các tính năng HM giống hệt mac)
        ./hosts/linux/default.nix 
      ];
    };
  };
}