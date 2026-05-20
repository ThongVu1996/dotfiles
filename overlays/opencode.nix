{
  lib,
  stdenv,
  fetchurl,
  unzip,
}:
stdenv.mkDerivation rec {
  pname = "opencode";
  version = "1.15.0";

  src = fetchurl {
    url = "https://github.com/anomalyco/opencode/releases/download/v${version}/opencode-darwin-arm64.zip";
    sha256 = "0bsd2ns1g5nvayga67mk70apghv2x55f1jji43kw8rw1h26jy1sg";
  };

  nativeBuildInputs = [ unzip ];

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/bin
    cp opencode $out/bin/
    chmod +x $out/bin/opencode
  '';

  meta = with lib; {
    description = "AI coding agent built for the terminal";
    homepage = "https://github.com/anomalyco/opencode";
    license = licenses.mit;
    platforms = [ "aarch64-darwin" ];
  };
}
