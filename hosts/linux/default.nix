{username, ...}: {
  imports = [
    ../../modules # Recursively auto-import all HM modules
    ./stylix.nix
  ];

  myConfig = {
    terminal = {
      tmux.enable = true;
      shells.enable = true;
      emulators.enable = true;
    };

    desktop = {
      aerospace.enable = false; # Disabled on linux
      apps.enable = true;
      zathura.enable = true;
    };

    editor.neovim.enable = true;

    dev.tools = {
      # For example, if you don't want web dev on Linux, you can set web.enable = false
      devops.enable = true;
      cli.enable = true;
      web.enable = true;
      misc.enable = true;
      ai.enable = true;
    };
  };

  home = {
    stateVersion = "24.11";
    enableNixpkgsReleaseCheck = false;
    inherit username;
    homeDirectory = "/home/${username}";
  };

  # Disable Home Manager's options.json build to silence spurious warnings
  manual = {
    json.enable = false;
    html.enable = false;
    manpages.enable = false;
  };

  xdg.enable = true;
}
