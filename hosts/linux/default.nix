{ config, pkgs, username, lib, ... }:

{
  imports = [
    ../../modules   # Auto-import đệ quy tất cả HM modules
  ];

  myConfig = {
    terminal.tmux.enable = true;
    terminal.shells.enable = true;
    terminal.emulators.enable = true;
    desktop.aerospace.enable = false;  # Tắt trên linux
    desktop.apps.enable = true;
    editor.neovim.enable = true;
    
    # Ở Linux ví dụ không muốn dev web, ta có thể tắt web.enable = false
    dev.tools.devops.enable = true;
    dev.tools.cli.enable = true;
    dev.tools.web.enable = true;
    dev.tools.misc.enable = true;
    dev.tools.ai.enable = true;
  };

  home.stateVersion = "24.11";
  home.enableNixpkgsReleaseCheck = false;
  
  # Tắt tính năng build options.json của HM để xoá warning
  manual.json.enable = false;
  
  home.username = username;
  home.homeDirectory = "/home/${username}";
  
  xdg.enable = true;
}
