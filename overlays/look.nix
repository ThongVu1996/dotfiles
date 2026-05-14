{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:
stdenvNoCC.mkDerivation rec {
  pname = "look";
  version = "0.5.0";

  src = fetchurl {
    url = "https://github.com/kunkka19xx/look/releases/download/v${version}/Look-${version}-macOS.zip";
    hash = "sha256-U1HOQb9qUbMeuUp1mbH/RkOJcRLYymh7nBg/jwWmN+U=";
  };

  nativeBuildInputs = [unzip];

  sourceRoot = ".";

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/Applications
    cp -r "Look.app" $out/Applications/
  '';

  meta = with lib; {
    description = "An open-source, community-driven launcher for macOS";
    homepage = "https://github.com/kunkka19xx/look";
    license = licenses.mit;
    platforms = platforms.darwin;
    mainProgram = "lookapp";
  };
}
