{
  pkgs,
  lib,
  username,
  ...
}: {
  # 1. SYSTEM-level Stylix Configuration
  stylix = {
    enable = true;
    autoEnable = false;
    image = ../../modules/core/wallpaper.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-soft.yaml";

    fonts = {
      monospace = {
        package = pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];};
        name = "JetBrainsMono Nerd Font";
      };
      sizes.terminal = 15;
    };
  };

  # 2. USER-level Configuration (Home Manager)
  home-manager.users."${username}" = {
    # SECTION 1: OPTIONS - Defined at the root of the user block
    options.qt.qt5ctSettings = lib.mkOption {
      type = lib.types.attrsOf (lib.types.attrsOf lib.types.anything);
      default = {};
      internal = true;
    };
    options.qt.qt6ctSettings = lib.mkOption {
      type = lib.types.attrsOf (lib.types.attrsOf lib.types.anything);
      default = {};
      internal = true;
    };

    # SECTION 2: CONFIGURATION - Must be wrapped in 'config'
    # since 'options' are defined above in this module scope.
    config = {
      stylix.targets = {
        tmux.enable = true;
        starship.enable = true;
        wezterm.enable = true;
      };
    };
  };
}
