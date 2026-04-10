function nix-list
    echo "📜 Fetching all system generations..."
    sudo -H nix-env --list-generations -p /nix/var/nix/profiles/system
end
