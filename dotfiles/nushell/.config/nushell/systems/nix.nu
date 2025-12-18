export-env {
    let nix_daemon_path = "/nix/var/nix/profiles/default/bin"
    if ($nix_daemon_path | path exists) {
        $env.PATH = ($env.PATH | split row (char esep) | prepend $nix_daemon_path)
    }
}

export def --wrapped nixss [...args] {
    let hostname = (scutil --get LocalHostName | str trim)
    let flake_path = ("~/nix-config" | path expand)
    
    # 1. Build bằng User thường (Không có sudo)
    print $"(ansi blue)🔨 Step 1: Building System [User Mode]...(ansi reset)"
    ^nix build $"($flake_path)#darwinConfigurations.($hostname).system"

    # 2. Kích hoạt bằng Root (Chỉ dùng sudo ở đây)
    print $"(ansi green)🚀 Step 2: Switching System [Root Mode]...(ansi reset)"
    sudo ./result/sw/bin/darwin-rebuild switch --flake $flake_path ...$args
}

export def "nix-clean" [] {
    print "🧹 Cleaning up Nix garbage..."
    sudo nix-collect-garbage -d
}
