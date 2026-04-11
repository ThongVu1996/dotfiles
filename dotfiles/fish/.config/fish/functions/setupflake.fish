function setupflake
    # 1. Verify Git repository
    if not test -d .git
        echo "❌ Error: Not a Git repository."
        return 1
    end

    # 2. Create flake.nix if it doesn't exist
    if not test -f flake.nix
        echo "🛠 Generating flake.nix..."
        genflake
    end

    # 3. Create .envrc with PATH mode (CRITICAL: path:.)
    if not test -f .envrc
        # Use path:. so Nix reads files directly without requiring 'git add'
        echo "use flake path:." > .envrc
        echo "✅ Created .envrc (using 'path:.' mode)"
    else
        # Update existing .envrc to use 'path:.' if missing
        if not grep -q "path:." .envrc
             echo "⚠️ Legacy .envrc detected, updating to 'path:.'..."
             sed -i '' 's/use flake/use flake path:./' .envrc
        end
    end

    # 4. Hide sensitive/generated files (Prevent accidental commits)
    set files_to_hide flake.nix flake.lock .envrc .direnv
    set exclude_file ".git/info/exclude"

    for file in $files_to_hide
        if not grep -q "$file" $exclude_file
            echo "$file" >> $exclude_file
            echo "🙈 Added $file to git exclude list (.git/info/exclude)"
        end
    end

    # 5. git add -N is no longer required when using 'path:.' mode.

    # 6. Activate Direnv
    echo "🚀 Activating Direnv..."
    direnv allow
end
