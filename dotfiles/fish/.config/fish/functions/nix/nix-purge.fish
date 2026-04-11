# =====================================================================
# NIX ENVIRONMENT PURGE HANDLER
# =====================================================================
# This function reverts all changes made by 'nix-init'.
# It removes local development files and restores git exclusion rules.

function nix-purge
    echo "🧹 Purging Nix development environment..."

    # 1. Remove environment and configuration files
    set files_to_remove flake.nix flake.lock .envrc
    for file in $files_to_remove
        if test -f $file
            rm $file
            echo "🗑️ Removed $file"
        end
    end

    # 2. Delete the .direnv cache directory
    if test -d .direnv
        rm -rf .direnv
        echo "🗑️ Removed .direnv directory"
    end

    # 3. Revert local git exclusion rules (clean up .git/info/exclude)
    set exclude_file ".git/info/exclude"
    if test -f $exclude_file
        # Portable way to use sed -i across different OS versions
        # Using a temporary file to ensure compatibility
        sed '/flake.nix/d; /.envrc/d; /flake.lock/d; /.direnv/d' "$exclude_file" > "$exclude_file.tmp"
        mv "$exclude_file.tmp" "$exclude_file"
        echo "✨ Restored .git/info/exclude to original state"
    end

    echo "✅ Project is now clean of local Nix environment configs."
end
