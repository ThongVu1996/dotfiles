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
  tree-sitter-blade = pkgs.stdenv.mkDerivation {
    name = "tree-sitter-blade-queries";
    src = pkgs.fetchFromGitHub {
      owner = "EmranMR";
      repo = "tree-sitter-blade";
      rev = "v0.12.3";
      hash = "sha256-3/gY68F+xOF5Fv6rK9cEIJCVDzg/3ap1/gzkEacGuy4=";
    };
    buildPhase = "true";
    installPhase = ''
      mkdir -p $out/queries/blade
      cp queries/*.scm $out/queries/blade/
    '';
  };
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
      plugins = [
        pkgs.vimPlugins.base16-nvim
        tree-sitter-blade
      ];

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
        tree-sitter-cli
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
        phpstan
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
