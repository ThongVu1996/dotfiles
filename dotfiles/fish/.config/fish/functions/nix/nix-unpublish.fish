# =====================================================================
# NIX ENVIRONMENT UNPUBLISH HANDLER (STEALTH MODE)
# =====================================================================
# This function reverts a public Nix setup back to a private/hidden state.
# It stops git tracking and cleans up .gitignore for total stealth.

function nix-unpublish
    echo "🕵️ Reverting Nix environment back to absolute stealth mode..."

    set nix_files flake.nix flake.lock .envrc
    
    # 1. Stop Git from tracking core Nix files (Keep them on disk)
    for file in $nix_files
        if test -f $file
            git rm --cached $file 2>/dev/null
            echo "🤫 Git is no longer tracking $file"
        end
    end

    # 2. Add files back to local git exclude list for private use
    set exclude_file ".git/info/exclude"
    if test -f $exclude_file
        for file in $nix_files .direnv
            if not grep -q "$file" $exclude_file
                echo "$file" >> $exclude_file
                echo "🙈 Added $file back to local exclude list"
            end
        end
    end

    # 3. Clean up the repo-wide .gitignore (Remove .direnv entry if exists)
    if test -f .gitignore
        if grep -q ".direnv" .gitignore
            # Portable cleanup of .gitignore using redirection
            sed '/.direnv/d' .gitignore > .gitignore.tmp
            mv .gitignore.tmp .gitignore
            echo "✨ Removed .direnv/ from .gitignore"
        end
    end

    echo "✅ Success! Your Nix environment is now 100% private and invisible to the repo."
end
