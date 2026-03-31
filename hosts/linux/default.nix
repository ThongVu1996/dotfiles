{ config, pkgs, username, lib, ... }:

{
  imports = [
    ../../modules/terminal/tmux.nix
    ../../modules/terminal/shells.nix
    ../../modules/desktop/aerospace.nix
    ../../modules/dev/default.nix
    ../../modules/editor/neovim.nix
  ];

  myConfig = {
    terminal.tmux.enable = true;
    terminal.shells.enable = true;
    desktop.aerospace.enable = false;  # Tắt trên linux
    editor.neovim.enable = true;
    
    # Ở Linux ví dụ không muốn dev web, ta có thể tắt web.enable = false
    dev.tools.devops.enable = true;
    dev.tools.cli.enable = true;
    dev.tools.web.enable = true;
    dev.tools.misc.enable = true;
  };

  home.stateVersion = "24.11";
  home.enableNixpkgsReleaseCheck = false;
  home.username = username;
  home.homeDirectory = "/home/${username}";
  
  xdg.enable = true;
}
