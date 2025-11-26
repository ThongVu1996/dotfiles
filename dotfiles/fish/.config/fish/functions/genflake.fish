function genflake
    if test -f flake.nix
        echo "❌ File flake.nix đã tồn tại! Không dám ghi đè."
        return 1
    end

    # Dùng echo và redirect thẳng vào file.
    # QUAN TRỌNG:
    # 1. Dùng dấu nháy kép "..." bao quanh toàn bộ nội dung.
    # 2. Phải thêm dấu \ trước ${system} (thành \${system}) để Fish không hiểu nhầm là biến.
    # 3. Dấu '' của shellHook vẫn giữ nguyên được vì nằm trong nháy kép.

    echo "{
  description = \"Môi trường Dev cho dự án\";

  inputs = {
    nixpkgs.url = \"github:nixos/nixpkgs/nixos-unstable\";
    flake-utils.url = \"github:numtide/flake-utils\";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.\${system};
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
          # thêm packages
          ];

          shellHook = ''
            echo \"🚀 Môi trường Dev đã sẵn sàng!\"
          '';
        };
      }
    );
}" > flake.nix

    echo "✅ Đã tạo flake.nix mẫu thành công!"
    echo "👉 Hãy chạy 'direnv allow' hoặc 'nix develop'"
end
