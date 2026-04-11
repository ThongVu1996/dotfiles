function nix-clean
    # 1. Detect which file types have changed in the current directory
    set changed_nix (git status --porcelain | grep '\.nix$')
    set changed_lua (git status --porcelain | grep '\.lua$')

    # --- NIX CLEANING ---
    if test -n "$changed_nix"
        echo "❄️  Nix files detected. Starting Nix Car Wash..."
        
        echo "🧹 1/3: Removing unused variables (deadnix)..."
        deadnix -e .
        
        echo "🔧 2/3: Fixing Nix anti-patterns (statix)..."
        statix fix .
        
        echo "✨ 3/3: Formatting Nix code (alejandra)..."
        alejandra -q .
    end

    # --- LUA CLEANING ---
    if test -n "$changed_lua"
        echo "🌙 Lua files detected. Starting Lua Polishing..."
        
        # You need 'stylua' installed in your Nix home.packages for this
        echo "✨ 1/1: Formatting Lua code (stylua)..."
        stylua .
    end

    # Final Status Check
    if test $status -eq 0
        echo "✅ Cleaning complete! Your workspace is optimized."
    else
        echo "❌ Error: One of the cleaning tools failed."
        return 1
    end
end