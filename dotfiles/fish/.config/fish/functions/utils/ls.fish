function ls
    # Check if there is exactly 1 argument AND it is a Number (e.g., 1, 2, 3...)
    if test (count $argv) -eq 1; and string match -qr '^[0-9]+$' $argv[1]
        eza --tree --level=$argv[1] --icons
    else
        # All other cases (ls, ls -la, ls /tmp...) run eza normally
        eza --icons $argv
    end
end
