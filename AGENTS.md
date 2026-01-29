# Agent Guidelines for Nix Config

## Build & Deploy
- **Apply Config**: `darwin-rebuild switch --flake .` (or `nix run nix-darwin -- switch --flake .`)
- **Check Validity**: `nix flake check`
- **Garbage Collect**: `nix-collect-garbage -d`

## Code Style & Conventions
- **Language**: Nix (strictly).
- **Formatting**: Use standard 2-space indentation. Align attribute sets.
- **Structure**: Prefer `let ... in` for local variables. Use `inherit` to reduce redundancy.
- **Imports**: Modularize config into `./darwin/` or `./home/` directories.
- **Flake**: All dependencies are managed in `flake.nix`. Do not use `nix-env -i`.
- **Symlinks**: Use `config.lib.file.mkOutOfStoreSymlink` for mutable dotfiles (e.g., nvim, tmux).
- **Secrets**: Do not commit secrets. Use environment variables or non-tracked files (e.g., `github_token`).

## Key Files
- `flake.nix`: Entry point defining inputs/outputs.
- `home.nix`: User-level packages & Home Manager config.
- `darwin/configuration.nix`: System-level macOS settings.
