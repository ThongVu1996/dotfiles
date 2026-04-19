{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  cmake,
  installShellFiles,
}:
rustPlatform.buildRustPackage rec {
  pname = "tree-sitter-cli";
  version = "0.26.1";

  src = fetchFromGitHub {
    owner = "tree-sitter";
    repo = "tree-sitter";
    rev = "v${version}";
    hash = "sha256-k8X2qtxUne8C6znYAKeb4zoBf+vffmcJZQHUmBvsilA=";
  };

  cargoHash = "sha256-hnFHYQ8xPNFqic1UYygiLBWu3n82IkTJuQvgcXcMdv0=";

  doCheck = false; # Skip tests to avoid failure in Nix sandbox environment

  nativeBuildInputs = [
    pkg-config
    cmake
    installShellFiles
  ];

  # Tree-sitter CLI typically doesn't require special buildInputs
  buildInputs = [];

  meta = with lib; {
    description = "Incremental parsing system for programming tools - CLI";
    homepage = "https://github.com/tree-sitter/tree-sitter";
    license = licenses.mit;
    mainProgram = "tree-sitter";
  };
}
