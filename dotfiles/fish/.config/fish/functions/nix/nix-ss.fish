function nix-ss --description "Multi-platform Build and Switch (Nix-Darwin / Home Manager)"
    # 🛠️ SET YOUR CONFIG PATH HERE
    # Replace this with the actual path to your nix-config folder
    set -l flake_path "$HOME/nix-config"

    # Identify the current Operating System
    set -l os_name (uname)

    # ============================
    # 🍎 MACOS CONFIGURATION (Darwin)
    # ============================
    if test "$os_name" = "Darwin"
        set -l host (hostname | cut -f1 -d.)
        echo "🍎 [macOS] Building configuration for: darwinConfigurations.$host..."
        
        # We point directly to the flake_path to avoid "searching up" warnings
        nix build "$flake_path#darwinConfigurations.$host.system"
        
        if test $status -eq 0
            echo "✅ Build successful! Administrator password required for switching..."
            # Using sudo -H for a clean environment switch
            sudo -H ./result/sw/bin/darwin-rebuild switch --flake "$flake_path"
            rm result
            echo "🎉 macOS integration complete."
        else
            echo "❌ macOS Flake build failed. Please check the logs."
        end

    # ============================
    # 🐧 LINUX CONFIGURATION (Home Manager Standalone)
    # ============================
    else if test "$os_name" = "Linux"
        set -l target "linux"
        echo "🐧 [Linux] Activating Home Manager for target: $target..."
        
        # Pointing to the flake_path eliminates the search warning
        home-manager switch --flake "$flake_path#$target"
        
        if test $status -eq 0
            echo "🎉 Linux integration complete."
        else
            echo "❌ Home Manager switch failed. Please check the logs."
        end

    # ============================
    # ⚠️ UNKNOWN OPERATING SYSTEM
    # ============================
    else
        echo "⚠️ Error: Platform '$os_name' is not recognized."
    end
end
