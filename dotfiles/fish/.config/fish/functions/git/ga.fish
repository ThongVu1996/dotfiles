function ga
    # Run your cleaning logic first
    nix-clean
    
    # Then run the actual git add command with whatever arguments you passed
    git add $argv
end