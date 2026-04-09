{ config, pkgs, lib, ... }:

let
  cfg = config.myConfig.dev.tools.misc;
in
{
  options.myConfig.dev.tools.misc = {
    enable = lib.mkEnableOption "Enable miscellaneous utilities (Git, ImageMagick, MacOS tools)";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      git imagemagick pngpaste lazygit
    ] ++ lib.optionals pkgs.stdenv.isDarwin [
      chafa luajit luajitPackages.luarocks 
      luajitPackages.magick switchaudio-osx
    ];

    home.sessionVariables = {
      PKG_CONFIG_PATH = lib.mkIf pkgs.stdenv.isDarwin "${pkgs.imagemagick.dev}/lib/pkgconfig";
    };
  };
}
