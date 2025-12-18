# env.nu
# --------------------------------------------------------
$env.XDG_CONFIG_HOME = ($env.HOME | path join ".config")
$env.LANG = "en_US.UTF-8"

# PATH: Định nghĩa cứng (Hardcode)
# Dùng 'prepend' để ưu tiên các gói cài qua Nix/Local hơn là System.
$env.PATH = ($env.PATH | prepend [
    # --- Nix Paths (Ưu tiên cao nhất) ---
    $"/etc/profiles/per-user/($env.USER)/bin"   # Nix User Profile
    "/run/current-system/sw/bin"                 # Nix System
    "/nix/var/nix/profiles/default/bin"          # Nix Default
    ($env.HOME | path join ".nix-profile/bin")
    "/Applications/VMware Fusion.app/Contents/Library"
    # --- Local Tools ---
    ($env.HOME | path join ".local/bin")
    
    # --- Homebrew (Hỗ trợ cả M1/M2 và Intel) ---
    "/opt/homebrew/bin"
    "/usr/local/bin"
    
    # --- Neovim/Mason ---
    ($env.HOME | path join ".local/share/nvim/mason/bin")
])

# Starship Init
mkdir ($env.HOME | path join ".cache/starship")
starship init nu | save -f ($env.HOME | path join ".cache/starship/init.nu")
