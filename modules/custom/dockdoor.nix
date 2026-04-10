{
  lib,
  stdenvNoCC, # Dùng stdenvNoCC vì ta không cần compile mã nguồn C/C++
  fetchurl,
  undmg,      # ⚠️ CÔNG CỤ HỖ TRỢ BUILD: Giải nén file .dmg trên macOS
}:

stdenvNoCC.mkDerivation rec {
  pname = "dockdoor";
  version = "1.34.1"; # Cập nhật version mới nhất trên GitHub Releases nếu cần

  src = fetchurl {
    url  = "https://github.com/ejbills/DockDoor/releases/download/${version}/DockDoor.dmg";
    hash = "sha256-w71AZN6mt/OEMl9Nfan43gbzVTrmPrG1tpIuENN8MOg=";
  };

  # --- CÔNG CỤ BUILD (biến mất sau khi build xong) ---
  # nativeBuildInputs đóng vai trò "thợ xây", ở đây ta cần 'undmg' để bung file DMG
  nativeBuildInputs = [ undmg ];

  # Định nghĩa nơi làm việc (file .dmg khi giải nén sẽ bung thẳng ra thư mục hiện tại)
  sourceRoot = ".";

  # --- VÌ LÀ PRE-BUILT BINARY ---
  dontBuild = true;

  installPhase = ''
    # Tạo thư mục Applications chuẩn của Nix
    mkdir -p $out/Applications
    
    # Copy toàn bộ app vào thư mục cài đặt
    cp -r "DockDoor.app" $out/Applications/
  '';

  meta = with lib; {
    description = "Window peeking, alt-tab and other enhancements for macOS";
    homepage    = "https://github.com/ejbills/DockDoor";
    license     = licenses.mit;
    platforms   = platforms.darwin; # ⚠️ Chỉ hỗ trợ hệ điều hành macOS
    mainProgram = "DockDoor";
  };
}