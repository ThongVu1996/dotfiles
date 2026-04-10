function nix-test
    # Check if a package name was provided
    if test (count $argv) -eq 0
        echo "❌ Error: No package name provided!"
        echo "💡 Usage: nix-test <package_name>"
        return 1
    end

    set -l pkg $argv[1]

    echo "🔍 Checking package: $pkg..."

    # Pre-check if the package exists in Nixpkgs
    if not nix-env -qaP $pkg > /dev/null 2>&1
        echo "⚠️  Warning: Package '$pkg' not found in Nixpkgs!"
        echo "🔎 Hint: Use 'nix-search $pkg' to find the correct name."
        
        # Ask for confirmation to proceed anyway
        read -l -P "❓ Do you still want to try opening the shell? [y/N]: " confirm
        if not string match -qi "y" -- $confirm
            return 1
        end
    end

    echo "🚀 Initializing temporary environment for $pkg..."
    # Launch nix-shell and enter Fish directly
    nix-shell -p $pkg --run fish
end
