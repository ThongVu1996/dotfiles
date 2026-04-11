{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "my-custom-duf";
  version = "0.9.1";

  # 1. Fetch source from GitHub
  src = fetchFromGitHub {
    owner = "muesli";
    repo = "duf";
    rev = "v${version}";
    # Temporary empty hash to force Nix error (for hash discovery)
    hash = "sha256-d/co7EaDk0m/oYxWFATxQYCdH3Z9r8eTtOOo+M+HD4o=";
  };

  # 2. Specify Go project and vendor hash
  # Also empty to force Nix error
  vendorHash = "sha256-Br2jagMynnzH77GNA7NeWbM5qSHbhfW5Bo7X2b6OX28=";

  # 3. Metadata (Optional for appearance)
  meta = with lib; {
    description = "Disk Usage/Free Utility - Custom build";
    homepage = "https://github.com/muesli/duf";
    license = licenses.mit;
  };
}
