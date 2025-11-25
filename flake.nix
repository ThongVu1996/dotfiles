{
  description = "Cấu hình hệ thống macOS với nix-darwin";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, darwin, ... }:
  let
    system = "aarch64-darwin"; # Chip Apple Silicon (M1/M2/M3)
    # system = "x86_64-darwin"; # Bật dòng này nếu dùng chip Intel
    
    # --- KHAI BÁO BIẾN QUAN TRỌNG ---
    username = "thongvu"; # <--- Dựa trên log của bạn (/Users/thongvu)
    hostname = "MacBook-Pro-cua-Thong"; # Thay bằng hostname thật của bạn nếu khác
  in
  {
    darwinConfigurations."${hostname}" = darwin.lib.darwinSystem {
      inherit system;
      modules = [
        ({ pkgs, ... }: {
          
          # 1. Khai báo người dùng (Bắt buộc)
          users.users."${username}" = {
            home = "/Users/${username}";
            description = username;
          };

          # 2. KHẮC PHỤC LỖI "Failed assertions" TẠI ĐÂY:
          # Chỉ định ai là user chính để áp dụng giao diện
          system.primaryUser = username; 
          
          nix.settings.trusted-users = [ "root" username ];

          # 3. Gói phần mềm
          environment.systemPackages = with pkgs; [
            vim
            git
            neofetch
          ];

          # 4. Cấu hình hệ thống
          system.defaults = {
            dock.autohide = true;
            finder.AppleShowAllExtensions = true;
            NSGlobalDomain.AppleInterfaceStyle = "Dark";
          };

          # 5. Cấu hình Nix
          # LƯU Ý: Đã XÓA dòng services.nix-daemon.enable = true (Gây lỗi)
          nix.settings.experimental-features = "nix-command flakes";
          
          system.stateVersion = 5; # Có thể để 4 hoặc 5 tùy phiên bản
        })
      ];
    };
  };
}
