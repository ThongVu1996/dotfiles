function ga --description 'Clean code then git add'
    # 1. Run your cleanup function first
    nix-clean

    # 2. Check if nix-clean ran successfully ($status == 0)
    if test $status -eq 0
        # 3. If successful, pass all user arguments (like ., -u, file_name) to git add
        git add $argv
        set_color green
        echo "📦 All clean files have been staged successfully!"
        set_color normal
    else
        # If a linter reports a fatal error (e.g., statix fails due to a syntax error), block the add
        set_color red
        echo "⛔ Fix the errors above before staging."
        set_color normal
        return 1
    end
end
