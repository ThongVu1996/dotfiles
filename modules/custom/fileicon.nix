{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
}:
stdenv.mkDerivation rec {
  pname = "fileicon";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "mklement0";
    repo = "fileicon";
    rev = "v${version}";
    sha256 = "03rrx9s0hp6qlc9qr4qi1lpm50rv64hs6qhyh0qqj16yz5ijg802";
  };

  # Use fallback hash if I can't find it
  # Actually, let's just use the URL directly since I saw it in the derivation
  # urls: ["https://github.com/mklement0/fileicon/archive/v0.3.4.tar.gz"]

  nativeBuildInputs = [makeWrapper];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    # Find the main script (it might be in bin/ or root)
    find . -type f -name "fileicon" -exec cp {} $out/bin/fileicon \;
    chmod +x $out/bin/fileicon
  '';

  meta = with lib; {
    description = "Mac OS X command-line utility to manage custom icons for files and folders";
    homepage = "https://github.com/mklement0/fileicon";
    license = licenses.mit;
    platforms = platforms.darwin;
  };
}
