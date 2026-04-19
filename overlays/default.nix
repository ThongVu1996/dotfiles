final: prev:
let
  # Use lib from nixpkgs
  lib = prev.lib;

  # Read all files in the current directory
  files = builtins.readDir ./.;

  # Function to check if a file is a valid package
  # Ignore default.nix, src folder (if it exists) and only keep .nix files or directories
  isPackage = name: type:
    (name != "default.nix") &&
    (name != "src") &&
    (type == "directory" || (type == "regular" && lib.hasSuffix ".nix" name));

  # Filter the file list
  packageFiles = lib.filterAttrs isPackage files;
in
# Convert the file list into a set of packages via callPackage
lib.mapAttrs'
  (name: type:
    let
      # Package name = file name minus the .nix suffix
      pname = lib.removeSuffix ".nix" name;
    in
    lib.nameValuePair pname (final.callPackage (./. + "/${name}") { })
  )
  packageFiles
  