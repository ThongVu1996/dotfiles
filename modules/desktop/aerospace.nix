{ config, pkgs, lib, ... }:

let
  cfg = config.myConfig.desktop.aerospace;
  dotfilesPath = "${config.home.homeDirectory}/nix-config/dotfiles";
in
{
  options.myConfig.desktop.aerospace = {
    enable = lib.mkEnableOption "Bật AeroSpace Tiling WM";
  };

  config = lib.mkIf cfg.enable {
    # AeroSpace chỉ chạy trên macOS
    home.packages = lib.optionals pkgs.stdenv.isDarwin [
      pkgs.aerospace
    ];

    xdg.configFile."aerospace/aerospace.toml".source = lib.mkIf pkgs.stdenv.isDarwin (config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/aerospace/.config/aerospace/aerospace.toml");
  };
}
