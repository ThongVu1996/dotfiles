{
  config,
  pkgs,
  lib,
  hostname,
  username,
  ...
}: let
  cfg = config.myConfig.editor.neovim;
  inherit (config.myConfig) dotfilesPath;

  # Strictly filter only base00 to base0F and prepend '#' for Neovim compatibility
  baseNames = ["base00" "base01" "base02" "base03" "base04" "base05" "base06" "base07" "base08" "base09" "base0A" "base0B" "base0C" "base0D" "base0E" "base0F"];
  palette = lib.genAttrs baseNames (name: "#${config.lib.stylix.colors.${name}}");
  stylixPalette = builtins.toJSON palette;
in {
  options.myConfig.editor.neovim = {
    enable = lib.mkEnableOption "Enable Neovim configuration and LSPs";
  };

  config = lib.mkIf cfg.enable {
    # 1. Disable Stylix target for Neovim to prevent init.lua conflicts with symlinks
    stylix.targets.neovim.enable = lib.mkForce false;

    programs.neovim = {
      enable = true;
      withRuby = false;
      withPython3 = true; # Enabled for plugins requiring python provider
      withNodeJs = true;
      plugins = [pkgs.vimPlugins.base16-nvim];

      # Inject palette via environment variable for zero-file integration logic
      extraWrapperArgs = [
        "--set"
        "STYLIX_PALETTE"
        "${stylixPalette}"
      ];
    };

    home.packages = let
      # --- 1. Neovim Core & Tree-sitter ---
      neovimTools = with pkgs; [
        (pkgs.callPackage ../custom/tree-sitter-cli.nix {})
        ripgrep
        fd
      ];

      # --- 2. Language Servers (LSP) ---
      lspServers = with pkgs; [
        lua-language-server
        vue-language-server
        vtsls
        tailwindcss-language-server
        emmet-language-server
        vscode-langservers-extracted
        intelephense
        phpactor
        markdown-oxide
        yaml-language-server
        nixd
      ];

      # --- 3. Formatting & Linting (conform & nvim-lint) ---
      formattingAndLinting = with pkgs; [
        stylua
        prettierd
        alejandra
        eslint_d
        cspell
        statix
        deadnix
      ];

      # --- 4. DevOps & Backend ---
      devopsTools = with pkgs; [
        terraform
        tflint
        tfsec
        python3Packages.mypy
        python3Packages.pylint
      ];

      # --- 5. Documentation & Extras ---
      docsTools = [pkgs.markdown-toc];
    in
      neovimTools ++ lspServers ++ formattingAndLinting ++ devopsTools ++ docsTools;

    # --- ENVIRONMENT VARIABLES ---
    # Global variables passed to Neovim and the system
    home.sessionVariables = {
      EDITOR = "nvim";
      HOSTNAME = hostname;
      USERNAME = username;
      FLAKE_PATH = "${dotfilesPath}";
    };

    # --- MAIN CONFIGURATION SYMLINK ---
    # Symlink the Neovim config directory directly to allow live editing.
    xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/nvim/.config/nvim";
  };
}
