{pkgs, ...}: {
  stylix = {
    enable = true;
    autoEnable = false;

    # Ensure the wallpaper path is relative to this file's location
    image = ../../modules/core/wallpaper.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-medium.yaml";

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
      sizes.terminal = 15;
    };

    # Group all targets here (No system/user distinction in standalone HM)
    targets = {
      tmux.enable = true;
      starship.enable = true;
      wezterm.enable = true;
      rio.enable = true;
    };
  };
}
