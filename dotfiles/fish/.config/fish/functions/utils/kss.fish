function kss --description 'Git add (optional), run nix-ss, and reload Kanata'
    # 1. Handle staging based on arguments
    if test (count $argv) -eq 0
        # No arguments provided, default to 'git add .'
        echo "📦 Staging all files (git add .)..."
        git add .
    else if test "$argv[1]" = "skip"
        # First argument is 'skip', bypass git add
        echo "⏭️  Skipping git add step..."
    else
        # Arguments provided, pass them all to git add
        echo "📦 Staging specified paths: $argv ..."
        git add $argv
    end

    # 2. Run the build command explicitly
    echo "🛠️  Running nix-ss..."
    nix-ss
    
    # Capture the exit status of nix-ss (0 means success, anything else is an error)
    set build_status $status

    # 3. Check the captured status
    if test $build_status -eq 0
        echo "✅ nix-ss build successful! Handling Kanata..."
        
        # Remove old error log if it exists (-f prevents errors if file is missing)
        sudo rm -f /Library/Logs/kanata.err.log

        # Find the Kanata process ID
        set kanata_pid (pgrep kanata)

        if test -n "$kanata_pid"
            # If process exists, kill it
            echo "🔪 Killing existing Kanata process (PID: $kanata_pid)..."
            sudo kill -9 $kanata_pid
            
            echo "⏳ Waiting 5 seconds for Kanata service to restart..."
            sleep 5
            
            # Read the new log
            if test -f /Library/Logs/kanata.err.log
                cat /Library/Logs/kanata.err.log
            end
            
            set_color green
            echo "🎉 Kanata reloaded successfully!"
            set_color normal
        else
            # If process does NOT exist, start it manually
            set_color yellow
            echo "⚠️ Kanata process not found. Starting manually..."
            set_color normal
            
            # Run Kanata manually with the correct config path
            sudo kanata --cfg ~/nix-config/modules/desktop/kanata/config.kbd
        end
    else
        # If build_status is not 0
        set_color red
        echo "❌ nix-ss build failed (Exit code: $build_status). Aborting Kanata reload."
        set_color normal
        return 1
    end
end
