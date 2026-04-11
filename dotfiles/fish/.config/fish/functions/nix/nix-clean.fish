function nix-clean
    echo "🧹 1/3: Removing unused variables (deadnix)..."
    deadnix -e .
    if test $status -ne 0
        echo "❌ Error: deadnix failed to clean variables."
        return 1
    end
    
    echo "🔧 2/3: Fixing Nix anti-patterns (statix)..."
    statix fix .
    if test $status -ne 0
        echo "❌ Error: statix failed to fix anti-patterns."
        return 1
    end
    
    echo "✨ 3/3: Formatting code (alejandra)..."
    alejandra -q .
    
    if test $status -eq 0
        echo "✅ Nix Car Wash complete! Your code is 100% clean."
    else
        echo "❌ Error: alejandra failed to format the code."
        return 1
    end
end