{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "my-custom-duf";
  version = "0.9.1";

  # 1. Kéo mã nguồn từ GitHub
  src = fetchFromGitHub {
    owner = "muesli";
    repo = "duf";
    rev = "v${version}";
    # Tạm thời để trống hash để ép Nix báo lỗi
    hash = "sha256-d/co7EaDk0m/oYxWFATxQYCdH3Z9r8eTtOOo+M+HD4o=";
  };

  # 2. Báo cho Nix biết đây là dự án Go, cần hash cho các thư viện (node_modules của Go)
  # Cũng để trống để ép Nix báo lỗi
  vendorHash = "sha256-Br2jagMynnzH77GNA7NeWbM5qSHbhfW5Bo7X2b6OX28=";

  # 3. Một chút thông tin metadata (Tùy chọn cho đẹp)
  meta = with lib; {
    description = "Disk Usage/Free Utility - Tự tay tôi build!";
    homepage = "https://github.com/muesli/duf";
    license = licenses.mit;
  };
}