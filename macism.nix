{ pkgs }:

pkgs.stdenv.mkDerivation {
  pname = "macism";
  version = "1.0.0";

  src = pkgs.fetchFromGitHub {
    owner = "laishulu";
    repo = "macism";
    rev = "1c5bf66ab0b33a3a9e69e51904d47984284da5b5"; 
    sha256 = "1qzsrpmx0pysp02vzd4bqmp6pr57ppd82qdxb13qcncv45a6imjc";
  };

  buildInputs = [ pkgs.swift ];

  # --- KHẮC PHỤC LỖI (Final Fix) ---
  buildPhase = ''
    # 1. Xóa thuộc tính @main trong TemporaryWindow.swift
    # (Đây là nguyên nhân gây xung đột duplicate symbol)
    sed -i '/@main/d' TemporaryWindow.swift

    # 2. KHÔNG đổi tên file macism.swift nữa.
    # Để nguyên cho nó dùng @main struct bên trong nó.
    
    # 3. Biên dịch tất cả
    swiftc *.swift -o macism
  '';
  # ---------------------------------

  installPhase = ''
    mkdir -p $out/bin
    cp macism $out/bin/
  '';

  meta = with pkgs.lib; {
    description = "Mac Input Source Manager";
    platforms = platforms.darwin;
  };
}
