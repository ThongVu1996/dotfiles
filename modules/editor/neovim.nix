{ config, pkgs, lib, ... }:

let
  cfg = config.myConfig.editor.neovim;
  dotfilesPath = config.myConfig.dotfilesPath;
in
{
  options.myConfig.editor.neovim = {
    enable = lib.mkEnableOption "Enable Neovim configuration and LSPs";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      neovim
      
      # Language Servers & Formatters
      lua-language-server stylua
      vue-language-server 
      tailwindcss-language-server 
      typescript-language-server
      emmet-language-server 
      vscode-langservers-extracted 
      prettierd eslint_d  
      typos-lsp 
      markdown-toc markdown-oxide
    ];

    home.sessionVariables = {
      EDITOR = "nvim";
    };

    # Symlink config folder
    xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/nvim/.config/nvim";
  };
}
