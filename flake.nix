{
  description = "Nix-darwin + Home Manager + Aerospace fully in Nix";

  inputs = {
    # Nixpkgs Unstable (để có software mới nhất)
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Nix Darwin
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Home Manager (Unstable/Master để hỗ trợ module Aerospace)
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, ... }:
  let
    system = "aarch64-darwin"; # Apple Silicon
    username = "thongvu";
    hostname = "MacBook-Pro";
  in
  {
    darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
      inherit system;
      
      # Truyền inputs vào để dùng ở các module con nếu cần
      specialArgs = {
        inherit self;
        inherit username;
      };

      modules = [
        ./darwin/configuration.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${username} = import ./home.nix;
          
          # Truyền thêm tham số cho Home Manager nếu cần
          home-manager.extraSpecialArgs = { inherit username; };
        }
      ];
    };
  };
}
