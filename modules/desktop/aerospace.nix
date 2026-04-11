{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.myConfig.desktop.aerospace;
  inherit (config.myConfig) dotfilesPath;
in {
  options.myConfig.desktop.aerospace = {
    enable = lib.mkEnableOption "Enable AeroSpace Tiling WM";
  };

  config = lib.mkIf cfg.enable {
    # AeroSpace only runs on macOS
    home.packages = lib.optionals pkgs.stdenv.isDarwin [
      pkgs.aerospace
    ];

    xdg.configFile."aerospace/aerospace.toml".source = lib.mkIf pkgs.stdenv.isDarwin (config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/aerospace/.config/aerospace/aerospace.toml");
  };
}
