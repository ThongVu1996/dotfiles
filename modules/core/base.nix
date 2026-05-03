_: {
  # Automatic system cleanup (Garbage Collection)
  nix.gc = {
    automatic = true;

    # --- SYNTAX FOR NIXOS (LINUX) ---
    dates = "weekly";

    # --- SYNTAX FOR NIX-DARWIN (MACOS) ---
    # In nix-darwin, you need to use 'interval' instead of 'dates'.
    # The example below runs at 00:00 every Sunday:
    # interval = { Weekday = 0; Hour = 0; Minute = 0; };

    # Delete generations older than 10 days
    options = "--delete-older-than 10d";
  };

  # Automatically optimize the Nix store (hardlink identical files)
  nix.settings.auto-optimise-store = true;
}
