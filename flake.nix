{
  description = "Cross-platform Nix Config (Nix-darwin + Home Manager)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, ... }@inputs:
  let
    username = "thongvu";
    hostname = "MacBook-Pro";
  in
  {
    # 1. Cấu hình cho macOS
    darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      
      specialArgs = { inherit self inputs username; };

      modules = [
        ./modules/common/packages.nix   # Nạp các app dùng chung
        ./modules/darwin/system.nix     # Nạp cấu hình macOS
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${username} = import ./home.nix;
          home-manager.extraSpecialArgs = { inherit inputs username; };
        }
      ];
    };

    # 2. Cấu hình dự phòng cho Linux (Standalone Home Manager)
    homeConfigurations."linux" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages."x86_64-linux";
      extraSpecialArgs = { inherit inputs username; };
      modules = [ 
        ./home.nix 
        # Nếu muốn dùng các app chung trên Linux, bạn có thể thiết lập thêm ở đây sau
      ];
    };
  };
}