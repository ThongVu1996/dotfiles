# =====================================================================
# NIX ENVIRONMENT PUBLISH HANDLER
# =====================================================================
# This function promotes a local/hidden Nix setup to a public one.
# It removes files from git exclude and stages them for commit.

function nix-publish
    echo "📢 Publishing local Nix environment to the repository..."

    # 1. Verification: Ensure files exist before publishing
    if not test -f flake.nix
        echo "❌ Error: flake.nix not found. Nothing to publish."
        return 1
    end

    # 2. Cleanup local git exclusion rules using portable sed redirection
    set exclude_file ".git/info/exclude"
    if test -f $exclude_file
        sed '/flake.nix/d; /flake.lock/d; /.envrc/d; /.direnv/d' "$exclude_file" > "$exclude_file.tmp"
        mv "$exclude_file.tmp" "$exclude_file"
        echo "🔓 Removed Nix files from local git exclude list"
    end

    # 3. Add to repository-wide .gitignore if missing (standard practice)
    if test -f .gitignore
        if not grep -q ".direnv" .gitignore
            echo ".direnv/" >> .gitignore
            echo "🙈 Added .direnv/ to .gitignore"
        end
    end

    # 4. Stage files for commit
    git add flake.nix flake.lock .envrc
    echo "✅ Files (flake.nix, flake.lock, .envrc) are staged and ready to commit!"
end
