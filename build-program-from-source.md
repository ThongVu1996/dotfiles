# 📦 Hướng Dẫn Tự Build Package Trên Nix
> Dành cho khi phần mềm **không có trên `nix search`**

---

## 🗂 Mục Lục

1. [Skeleton chuẩn](#1-skeleton-chuẩn)
2. [Bảng đọc vị repo](#2-bảng-đọc-vị-repo)
3. [Ví dụ từng ngôn ngữ](#3-ví-dụ-từng-ngôn-ngữ)
4. [Trường hợp đặc biệt: Pre-built Binary](#4-trường-hợp-đặc-biệt-pre-built-binary)
5. [Cách tích hợp vào hệ thống](#5-cách-tích-hợp-vào-hệ-thống)
6. [Nghi thức lấy Hash](#6-nghi-thức-lấy-hash)
7. [nativeBuildInputs vs buildInputs](#7-nativebuildInputs-vs-buildinputs)
8. [Lỗi thường gặp](#8-lỗi-thường-gặp)

---

## 1. Skeleton Chuẩn

Lưu file này tại `modules/custom/my-app.nix`:

```nix
{
  lib,
  stdenv,
  fetchFromGitHub,

  # --- CHỌN BỘ BUILDER PHÙ HỢP (bỏ comment dòng cần dùng) ---
  # buildGoModule,      # Cho Go     (có go.mod)
  # buildRustPackage,   # Cho Rust   (có Cargo.toml)
  # buildNpmPackage,    # Cho Node   (có package.json)
  # python3Packages,    # Cho Python (có setup.py / pyproject.toml)

  # --- CÔNG CỤ HỖ TRỢ BUILD (biến mất sau khi build xong) ---
  pkg-config,
  cmake,

  # --- THƯ VIỆN HỆ THỐNG (nằm lại trong bộ cài) ---
  openssl,
  zlib,
}:

# ⚠️ Thay 'stdenv.mkDerivation' bằng builder tương ứng nếu cần
stdenv.mkDerivation rec {
  pname = "ten-ung-dung";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner  = "ten-tac-gia";
    repo   = pname;
    rev    = "v${version}";
    hash   = lib.fakeHash; # Bước 1: để fakeHash → chạy build → lấy hash thật
  };

  # --- HASH PHỤ THEO NGÔN NGỮ (xóa nếu không dùng) ---
  # vendorHash  = lib.fakeHash; # buildGoModule
  # cargoHash   = lib.fakeHash; # buildRustPackage
  # npmDepsHash = lib.fakeHash; # buildNpmPackage

  # --- CÔNG CỤ BUILD ---
  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  # --- THƯ VIỆN RUNTIME ---
  buildInputs = [
    openssl
    zlib
  ];

  # --- NẾU LÀ BINARY CÀI SẴN (xóa nếu không dùng) ---
  # dontBuild = true;
  # installPhase = ''
  #   mkdir -p $out/bin
  #   cp ten-file-chay $out/bin/
  #   chmod +x $out/bin/ten-file-chay
  # '';

  meta = with lib; {
    description = "Mô tả ngắn gọn về phần mềm";
    homepage    = "https://github.com/user/repo";
    license     = licenses.mit; # gpl3Only, asl20, bsd3...
    platforms   = platforms.all;
    mainProgram = pname;        # Tên lệnh chạy trong terminal
  };
}
```

> **Tại sao dùng `lib.fakeHash` thay vì `""`?**
> Để trống `""` gây lỗi cú pháp. `lib.fakeHash` cho phép Nix chạy và trả về hash thật trong thông báo lỗi.

---

## 2. Bảng Đọc Vị Repo

Nhìn vào danh sách file trong repo GitHub → chọn builder tương ứng:

| File thấy trong repo | Builder | Hash phụ cần thêm |
|---|---|---|
| `go.mod`, `go.sum` | `buildGoModule` | `vendorHash` |
| `Cargo.toml`, `Cargo.lock` | `buildRustPackage` | `cargoHash` |
| `package.json`, `package-lock.json` | `buildNpmPackage` | `npmDepsHash` |
| `setup.py`, `pyproject.toml` | `buildPythonPackage` | Không cần |
| `CMakeLists.txt` | `stdenv.mkDerivation` + `cmake` | Không cần |
| `Makefile` | `stdenv.mkDerivation` | Không cần |
| Chỉ có file binary `.tar.gz` / `.zip` | `stdenv.mkDerivation` + `autoPatchelfHook` | Không cần |

---

## 3. Ví Dụ Từng Ngôn Ngữ

### 🔵 Go (`go.mod`)

```nix
{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname   = "my-go-app";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "author";
    repo  = pname;
    rev   = "v${version}";
    hash  = lib.fakeHash;      # Bước 1
  };

  vendorHash = lib.fakeHash;   # Bước 2 (sau khi có hash src)

  meta = with lib; {
    description = "Go app";
    license     = licenses.mit;
    mainProgram = pname;
  };
}
```

---

### 🟠 Rust (`Cargo.toml`)

```nix
{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname   = "my-rust-app";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "author";
    repo  = pname;
    rev   = "v${version}";
    hash  = lib.fakeHash;      # Bước 1
  };

  cargoHash = lib.fakeHash;    # Bước 2

  meta = with lib; {
    description = "Rust app";
    license     = licenses.mit;
    mainProgram = pname;
  };
}
```

---

### 🟢 Node.js (`package.json`)

```nix
{ lib, buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname   = "my-node-app";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "author";
    repo  = pname;
    rev   = "v${version}";
    hash  = lib.fakeHash;      # Bước 1
  };

  npmDepsHash = lib.fakeHash;  # Bước 2

  meta = with lib; {
    description = "Node app";
    license     = licenses.mit;
    mainProgram = pname;
  };
}
```

---

### 🐍 Python (`setup.py` / `pyproject.toml`)

```nix
{ lib, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonPackage rec {
  pname   = "my-python-app";
  version = "2.1.0";
  format  = "pyproject"; # hoặc "setuptools" nếu dùng setup.py

  src = fetchFromGitHub {
    owner = "author";
    repo  = pname;
    rev   = "v${version}";
    hash  = lib.fakeHash;
  };

  # Dependencies Python (tìm tên trong nixpkgs)
  propagatedBuildInputs = with python3Packages; [
    requests
    click
  ];

  meta = with lib; {
    description = "Python app";
    license     = licenses.mit;
    mainProgram = pname;
  };
}
```

---

## 4. Trường Hợp Đặc Biệt: Pre-built Binary

Dành cho phần mềm **đóng mã nguồn**, chỉ phân phối dạng binary (`.tar.gz`, `.zip`):

```nix
{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,  # ⚠️ BẮT BUỘC cho binary trên Linux/NixOS
  openssl,           # Thêm các thư viện mà binary phụ thuộc
}:

stdenv.mkDerivation rec {
  pname   = "my-binary-app";
  version = "1.0.0";

  src = fetchurl {
    url  = "https://example.com/releases/v${version}/app-linux-amd64.tar.gz";
    hash = lib.fakeHash;
  };

  # autoPatchelfHook tự động fix dynamic linking trên NixOS
  nativeBuildInputs = [ autoPatchelfHook ];

  # Thư viện mà binary cần (autoPatchelf sẽ tìm ở đây)
  buildInputs = [ openssl ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp my-app $out/bin/
    chmod +x $out/bin/my-app
  '';

  meta = with lib; {
    description = "Pre-built binary app";
    license     = licenses.unfree;
    platforms   = platforms.linux;
    mainProgram = pname;
  };
}
```

> **`autoPatchelfHook` là gì?**
> NixOS không dùng `/lib` hệ thống. Binary thông thường sẽ không tìm thấy thư viện. `autoPatchelfHook` tự động vá đường dẫn thư viện cho đúng. **Thiếu nó, binary sẽ báo lỗi "not found" khi chạy.**

---

## 5. Cách Tích Hợp Vào Hệ Thống

### Cách 1: Gọi trực tiếp trong `home.nix` (khuyến nghị)

```nix
{ config, pkgs, lib, username, ... }:
let
  myApp = pkgs.callPackage ./modules/custom/my-app.nix {};
in
{
  home.packages = [
    myApp
    # ... các package khác
  ];
}
```

### Cách 2: Nhiều package custom cùng lúc

```nix
let
  myApp  = pkgs.callPackage ./modules/custom/my-app.nix {};
  myTool = pkgs.callPackage ./modules/custom/my-tool.nix {};
in
{
  home.packages = [ myApp myTool ];
}
```

### Cấu trúc thư mục gợi ý

```
modules/
└── custom/
    ├── my-app.nix      # Mỗi package là 1 file riêng
    ├── my-tool.nix
    └── my-binary.nix
```

---

## 6. Nghi Thức Lấy Hash

Thực hiện theo thứ tự, **không được bỏ bước**:

### Bước 1: Lấy hash của source code

```nix
hash = lib.fakeHash; # Để vậy
```

```bash
darwin-rebuild switch --flake .
# Lỗi sẽ hiện:
#   got:      sha256-ABC123...
```

Điền hash vừa lấy vào:
```nix
hash = "sha256-ABC123...";
```

### Bước 2: Lấy hash phụ (Go/Rust/Node)

```nix
vendorHash = lib.fakeHash; # Để vậy sau khi đã có hash src
```

```bash
darwin-rebuild switch --flake .
# Lỗi sẽ hiện:
#   got:      sha256-XYZ789...
```

Điền hash vừa lấy vào:
```nix
vendorHash = "sha256-XYZ789...";
```

### Bước 3: Build thành công

```bash
darwin-rebuild switch --flake .
# ✅ Không còn lỗi hash → build hoàn tất
```

> **Lệnh tương ứng theo môi trường:**
> - macOS (nix-darwin): `darwin-rebuild switch --flake .`
> - NixOS: `sudo nixos-rebuild switch --flake .`
> - Standalone Home Manager: `home-manager switch --flake .`

---

## 7. nativeBuildInputs vs buildInputs

### Khái niệm cốt lõi

Hãy tưởng tượng bạn đang **xây một ngôi nhà**:

- `nativeBuildInputs` = **Thợ xây + máy móc công trường** → chỉ cần khi đang xây, xong việc thì về
- `buildInputs` = **Hệ thống điện, nước, ống gas** → gắn vào nhà vĩnh viễn, cần để nhà hoạt động

---

### `nativeBuildInputs` — Công cụ để BUILD

**Đặc điểm:**
- Chạy **trên máy bạn** (máy đang build)
- **Biến mất** sau khi build xong — không có trong bản cài cuối
- Quan trọng khi cross-compile (build trên x86 cho ARM)

| Package | Vai trò |
|---|---|
| `pkg-config` | Giúp compiler tìm đường dẫn thư viện |
| `cmake` | Hệ thống build (đọc `CMakeLists.txt`) |
| `meson` | Hệ thống build thay thế cmake |
| `ninja` | Chạy build song song, nhanh hơn make |
| `autoPatchelfHook` | Vá đường dẫn thư viện cho binary |
| `installShellFiles` | Cài man page, shell completion |
| `rustc`, `cargo` | Compiler Rust |
| `go` | Compiler Go |

---

### `buildInputs` — Thư viện để CHẠY

**Đặc điểm:**
- **Nằm lại** trong bản cài cuối
- Là những gì binary cần để **chạy được** sau khi cài
- Nix tự động link chúng vào đúng chỗ

| Package | Vai trò |
|---|---|
| `openssl` | Mã hóa, HTTPS |
| `zlib` | Nén/giải nén |
| `sqlite` | Database nhúng |
| `libgit2` | Git operations |
| `imagemagick` | Xử lý ảnh |
| `ffmpeg` | Xử lý video/audio |
| `gtk3`, `gtk4` | UI framework |

---

### ⚠️ Lưu ý quan trọng: `pkg-config` phải đi cùng thư viện

```nix
# ✅ ĐÚNG — pkg-config tìm được openssl vì openssl có trong buildInputs
nativeBuildInputs = [ pkg-config cmake ];
buildInputs       = [ openssl ];

# ❌ SAI — openssl để sai chỗ, pkg-config không tìm được
nativeBuildInputs = [ pkg-config cmake openssl ];
buildInputs       = [];
```

`pkg-config` đọc file `.pc` của thư viện nằm trong `buildInputs` để lấy đường dẫn header và lib. Thiếu thư viện trong `buildInputs` thì `pkg-config` không tìm được gì.

---

### Sơ đồ luồng build

```
Source Code
    │
    ▼
┌─────────────────────────────────┐
│           BUILD PHASE           │
│                                 │
│  nativeBuildInputs:             │
│  ├── pkg-config  ──┐            │
│  ├── cmake       ──┼──────────► │ compile → binary
│  └── ninja       ──┘            │
│                                 │
│  buildInputs (headers):         │
│  ├── openssl.dev ─────────────► │ #include <openssl/ssl.h>
│  └── zlib.dev    ─────────────► │ #include <zlib.h>
└─────────────────────────────────┘
    │
    ▼
┌─────────────────────────────────┐
│        RUNTIME (bản cài)        │
│                                 │
│  buildInputs (libs):            │
│  ├── openssl ──────────────►    │ libssl.so (còn ở đây)
│  └── zlib    ──────────────►    │ libz.so   (còn ở đây)
│                                 │
│  nativeBuildInputs: ✗           │ (đã biến mất)
└─────────────────────────────────┘
```

---

### Cách xác định cần thêm gì

**Cách 1: Đọc lỗi khi build (nhanh nhất)**

Cứ để trống rồi chạy, Nix sẽ tự báo thiếu gì:

| Lỗi báo | Thiếu gì | Thêm vào đâu |
|---|---|---|
| `Package openssl not found` | `pkg-config` + `openssl` | native + build |
| `cmake: command not found` | `cmake` | `nativeBuildInputs` |
| `fatal error: zlib.h: No such file` | `zlib` | `buildInputs` |
| `libssl.so not found` khi **chạy** | `openssl` | `buildInputs` |
| `ninja: command not found` | `ninja` | `nativeBuildInputs` |

> **Quy tắc đọc lỗi:**
> - Lỗi lúc **build** → `nativeBuildInputs`
> - Lỗi lúc **chạy** sau khi đã cài xong → `buildInputs`

---

**Cách 2: Đọc file build của repo (chắc chắn nhất)**

Vào GitHub của phần mềm, tìm các file sau:

`CMakeLists.txt` — tìm `find_package`:
```cmake
find_package(OpenSSL REQUIRED)   → buildInputs = [ openssl ]
find_package(ZLIB REQUIRED)      → buildInputs = [ zlib ]
find_package(SQLite3 REQUIRED)   → buildInputs = [ sqlite ]
```
Và luôn cần thêm vào native:
```nix
nativeBuildInputs = [ cmake pkg-config ];
```

`Makefile` — tìm `pkg-config` hoặc `-l`:
```makefile
LIBS = $(shell pkg-config --libs openssl)  → pkg-config + openssl
LDFLAGS = -lz -lssl                        → zlib + openssl
```

`README.md` — phần Dependencies (nhanh nhất, hầu hết repo có):
```markdown
## Dependencies
- openssl >= 1.1    → buildInputs = [ openssl ]
- cmake >= 3.20     → nativeBuildInputs = [ cmake ]
```

---

**Cách 3: Copy từ nixpkgs (an toàn nhất)**

Tìm package tương tự trong nixpkgs để học:
```bash
nix edit nixpkgs#curl    # xem curl dùng gì
nix edit nixpkgs#wget    # xem wget dùng gì
```

---

**Bảng tra nhanh theo chức năng**

| App cần làm gì | `nativeBuildInputs` | `buildInputs` |
|---|---|---|
| Kết nối HTTPS | `pkg-config` | `openssl` |
| Nén/giải nén | — | `zlib` |
| Đọc/ghi ảnh | `pkg-config` | `imagemagick` |
| Database local | `pkg-config` | `sqlite` |
| Git operations | `pkg-config` | `libgit2` |
| Hiển thị UI | `pkg-config` | `gtk4` |
| Đọc XML | `pkg-config` | `libxml2` |
| Xử lý video | `pkg-config` | `ffmpeg` |
| Build C/C++ | `cmake` hoặc `meson` | — |

---

**Quy trình thực tế khuyến nghị**

```
1. Đọc README → mục Dependencies/Requirements
       ↓
2. Thấy cmake/meson → nativeBuildInputs
   Thấy openssl/zlib/... → buildInputs
       ↓
3. Chạy build → đọc lỗi → bổ sung thêm
       ↓
4. Build xong → thử chạy → nếu lỗi .so → thêm vào buildInputs
       ↓
5. ✅ Xong
```

> Thực tế **80% trường hợp** chỉ cần bước 1 + 3 là đủ.

---

## 8. Lỗi Thường Gặp

| Lỗi | Nguyên nhân | Cách sửa |
|---|---|---|
| `hash mismatch` | Hash sai hoặc để `""` | Dùng `lib.fakeHash`, lấy hash từ lỗi |
| `command not found` sau install | Thiếu `mainProgram` hoặc sai tên binary | Thêm `mainProgram = "ten-lenh";` vào meta |
| Binary báo `not found` trên NixOS | Thiếu `autoPatchelfHook` | Thêm vào `nativeBuildInputs` |
| `cannot find -lssl` | Thiếu `openssl` | Thêm `openssl` vào `buildInputs` |
| Go build lỗi network | Nix build trong sandbox không có mạng | Dùng đúng `vendorHash` |
| `attribute 'python315' missing` | Phiên bản không tồn tại | Kiểm tra `nix search nixpkgs python3` |

---

## 📋 Checklist Trước Khi Build

- [ ] Đã xác định đúng builder từ bảng đọc vị
- [ ] Dùng `lib.fakeHash` thay vì `""`
- [ ] Khai báo đủ `nativeBuildInputs` và `buildInputs`
- [ ] Với binary: đã thêm `autoPatchelfHook`
- [ ] Đã gọi `pkgs.callPackage` trong `home.nix`
- [ ] Thực hiện đủ các bước lấy hash theo thứ tự
