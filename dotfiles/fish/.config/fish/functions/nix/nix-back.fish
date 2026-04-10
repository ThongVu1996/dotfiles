function nix-back
    set -l gen $argv[1]
    if test -z "$gen"
        echo "⚠️ Error: Please provide a generation number (Example: n-back 72)"
        return 1
    end
    
    echo "🔄 Switching system profile to generation: $gen..."
    
    # Using -H for both switching and activating
    sudo -H nix-env --switch-generation $gen -p /nix/var/nix/profiles/system
    
    if test $status -eq 0
        echo "🚀 Activating system configuration..."
        sudo -H /nix/var/nix/profiles/system/activate
        echo "✅ Successfully rolled back to generation $gen!"
        nix-current
    else
        echo "❌ Switch failed. Please verify if the generation number exists."
    end
end
