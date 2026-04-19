{
  lib,
  stdenvNoCC, # Using stdenvNoCC as no C/C++ compilation is required
  fetchurl,
  undmg, # Build tool: Extracts .dmg files on macOS
}:
stdenvNoCC.mkDerivation rec {
  pname = "dockdoor";
  version = "1.34.1"; # Update to the latest version from GitHub Releases if needed

  src = fetchurl {
    url = "https://github.com/ejbills/DockDoor/releases/download/${version}/DockDoor.dmg";
    hash = "sha256-w71AZN6mt/OEMl9Nfan43gbzVTrmPrG1tpIuENN8MOg=";
  };

  # --- BUILD TOOLS (removed after build) ---
  # nativeBuildInputs acts as the "builder", here we need 'undmg' to extract the DMG
  nativeBuildInputs = [undmg];

  # Define workspace (DMG extraction happens in current directory)
  sourceRoot = ".";

  # --- PRE-BUILT BINARY ---
  dontBuild = true;

  installPhase = ''
    # Create standard macOS Applications directory
    mkdir -p $out/Applications

    # Copy the whole app bundle to the installation directory
    cp -r "DockDoor.app" $out/Applications/
  '';

  meta = with lib; {
    description = "Window peeking, alt-tab and other enhancements for macOS";
    homepage = "https://github.com/ejbills/DockDoor";
    license = licenses.mit;
    platforms = platforms.darwin; # macOS only
    mainProgram = "DockDoor";
  };
}
