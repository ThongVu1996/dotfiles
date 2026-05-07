function nix-dev-init -d "Initialize custom devenv template and ignore Git tracking"
    # 1. Check for Git repository first
    if not test -d .git
        echo "⚠️  No Git repository found. Please run 'git init' first to create a .git directory."
        return 1
    end

    # 2. Check if files already exist and prompt the user
    if test -f devenv.nix -o -f .envrc -o -f devenv.yaml
        read -P "⚠️  Devenv files already exist. Do you want to skip initialization? [Y/n] " confirm
        
        # Default to 'Yes' if user just presses Enter, or explicitly types 'y'/'Y'
        if test -z "$confirm" -o "$confirm" = "y" -o "$confirm" = "Y"
            echo "⏭️  Skipped initialization. Existing files were kept."
            return 0
        end
        echo "🔄 Proceeding to overwrite existing files..."
    end

    # 3. Create .envrc with devenv integration
    echo 'eval "$(devenv direnvrc)"' > .envrc
    echo 'use devenv' >> .envrc

    # 4. Create devenv.yaml
    echo "inputs:
  nixpkgs:
    url: github:NixOS/nixpkgs/nixos-unstable" > devenv.yaml

    # 5. Create devenv.nix (Using concise Nix syntax with 'with pkgs;')
    echo '{ pkgs, ... }:

{
  # Default packages to install
  packages = with pkgs; [
    hello
  ];

  enterShell = '\'''\''
    echo "🚀 Devenv environment is ready!"
  '\'''\'';
}' > devenv.nix

    # 6. Handle Git tracking
    set -l exclude_file ".git/info/exclude"
    
    for file in .envrc devenv.nix devenv.yaml .devenv/
        if not grep -q "^$file\$" $exclude_file 2>/dev/null
            echo $file >> $exclude_file
        end
    end

    # Untrack files if they were accidentally added/committed previously
    git rm --cached .envrc devenv.nix devenv.yaml -q 2>/dev/null
    
    echo "✅ Added environment files to .git/info/exclude (Hidden from Git)."

    # 7. Automatically allow direnv
    if type -q direnv
        direnv allow
        echo "✅ Executed 'direnv allow'."
    end

    echo "🎉 Environment initialization complete!"
end
