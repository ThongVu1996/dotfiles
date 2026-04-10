function nix-current
    echo "🔍 Identifying the active system profile..."
    # -H ensures sudo uses root's home, keeping Nix security happy
    sudo -H nix-env --list-generations -p /nix/var/nix/profiles/system | grep "current"
end
