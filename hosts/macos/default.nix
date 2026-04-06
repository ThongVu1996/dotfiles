{ config, pkgs, username, ... }:

{
  imports = [
    ./system.nix
  ];

  networking.hostName = "MacBook-Pro";
  
  home-manager.users.${username} = { pkgs, config, lib, ... }: {
    imports = [
      ../../modules   # Auto-import đệ quy tất cả HM modules
    ];

    myConfig = {
      terminal.tmux.enable = true;
      terminal.shells.enable = true;
      terminal.emulators.enable = true;
      desktop.aerospace.enable = true;
      desktop.apps.enable = true;
      editor.neovim.enable = true;
      
      # Môi trường Dev (Có thể bật/tắt từng cái linh hoạt)
      dev.tools.devops.enable = true;
      dev.tools.cli.enable = true;
      dev.tools.web.enable = true;
      dev.tools.misc.enable = true;
      dev.tools.ai.enable = true;
    };

    home.stateVersion = "24.11";
    home.enableNixpkgsReleaseCheck = false;
    
    # Tắt tính năng build options.json của Home Manager để triệt tiêu warning rác từ các flake inputs
    manual.json.enable = false;
  };
}

