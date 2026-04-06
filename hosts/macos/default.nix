{ config, pkgs, username, ... }:

{
  imports = [
    ./system.nix
  ];

  networking.hostName = "MacBook-Pro";
  
  home-manager.users.${username} = { pkgs, config, lib, ... }: {
    imports = [
      ../../modules   # Recursively auto-import all HM modules
    ];

    myConfig = {
      terminal.tmux.enable = true;
      terminal.shells.enable = true;
      terminal.emulators.enable = true;
      desktop.aerospace.enable = true;
      desktop.apps.enable = true;
      editor.neovim.enable = true;
      
      # Dev Environment (can be toggled individually)
      dev.tools.devops.enable = true;
      dev.tools.cli.enable = true;
      dev.tools.web.enable = true;
      dev.tools.misc.enable = true;
      dev.tools.ai.enable = true;
    };

    home.stateVersion = "24.11";
    home.enableNixpkgsReleaseCheck = false;
    
    # Disable Home Manager's options.json build to silence spurious warnings from flake inputs
    manual.json.enable = false;
  };
}

