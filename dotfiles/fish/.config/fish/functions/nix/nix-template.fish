function nix-template
    if test -f flake.nix
        echo "❌ Error: flake.nix already exists! Will not overwrite."
        return 1
    end

    # Generate template with escaping for Fish compatibility
    echo "{
  description = \"Project Dev Environment\";

  inputs = {
    nixpkgs.url = \"github:nixos/nixpkgs/nixos-unstable\";
    flake-utils.url = \"github:numtide/flake-utils\";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.\${system};
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            # Add packages here
          ];

          shellHook = ''
            echo \"🚀 Dev shell activated!\"
          '';
        };
      }
    );
}" > flake.nix

    echo "✅ Template flake.nix generated successfully!"
    echo "👉 Run 'direnv allow' or 'nix develop' to start."
end
