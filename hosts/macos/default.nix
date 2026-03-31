{ config, pkgs, username, ... }:

{
  imports = [
    ../../modules/core/mac-system.nix
  ];

  networking.hostName = "MacBook-Pro";
  
  home-manager.users.${username} = { pkgs, config, lib, ... }: {
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
      desktop.aerospace.enable = true;
      editor.neovim.enable = true;
      
      # Môi trường Dev (Có thể bật/tắt từng cái linh hoạt)
      dev.tools.devops.enable = true;
      dev.tools.cli.enable = true;
      dev.tools.web.enable = true;
      dev.tools.misc.enable = true;
    };

    home.stateVersion = "24.11";
    home.enableNixpkgsReleaseCheck = false;
  };
}
