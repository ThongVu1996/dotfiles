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
      # Neovim dependencies
      neovim
      
      # Web & Modern Scripting
      lua-language-server stylua
      vue-language-server 
      tailwindcss-language-server 
      vtsls
      emmet-language-server 
      vscode-langservers-extracted 
      
      # Formatters & Linters
      prettierd eslint_d  
      cspell # Spell checker
      
      # PHP Environment
      intelephense 
      
      # Markdown & Docs
      markdown-toc markdown-oxide
      yaml-language-server
    ];

    home.sessionVariables = {
      EDITOR = "nvim";
    };

    # Symlink config folder
    xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/nvim/.config/nvim";
  };
}
