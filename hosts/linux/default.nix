{ config, pkgs, username, lib, ... }:

{
  imports = [
    ../../modules   # Recursively auto-import all HM modules
  ];

  myConfig = {
    terminal.tmux.enable = true;
    terminal.shells.enable = true;
    terminal.emulators.enable = true;
    desktop.aerospace.enable = false;  # Disabled on linux
    desktop.apps.enable = true;
    editor.neovim.enable = true;
    
    # For example, if you don't want web dev on Linux, you can set web.enable = false
    dev.tools.devops.enable = true;
    dev.tools.cli.enable = true;
    dev.tools.web.enable = true;
    dev.tools.misc.enable = true;
    dev.tools.ai.enable = true;
  };

  home.stateVersion = "24.11";
  home.enableNixpkgsReleaseCheck = false;
  
  # Disable Home Manager's options.json build to silence spurious warnings
  manual.json.enable = false;
  manual.html.enable = false;
  manual.manpages.enable = false;
  
  home.username = username;
  home.homeDirectory = "/home/${username}";
  
  xdg.enable = true;
}
