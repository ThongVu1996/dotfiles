{ config, pkgs, lib, ... }:

let
  cfg = config.myConfig.dev.tools.misc;
in
{
  options.myConfig.dev.tools.misc = {
    enable = lib.mkEnableOption "Bật các công cụ phụ trợ (Git, ImageMagick, MacOS tools)";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      git mkalias keepassxc claude-code
      imagemagick pngpaste wezterm
    ] ++ lib.optionals pkgs.stdenv.isDarwin [
      rio chafa luajit luajitPackages.luarocks 
      luajitPackages.magick opencode switchaudio-osx
    ];

    home.sessionVariables = {
      PKG_CONFIG_PATH = lib.mkIf pkgs.stdenv.isDarwin "${pkgs.imagemagick.dev}/lib/pkgconfig";
    };

    xdg.configFile."rio/config.toml".source = lib.mkIf pkgs.stdenv.isDarwin (config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/dotfiles/rio/.config/rio/config.toml");
    xdg.configFile."wezterm".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/dotfiles/wezterm/.config/wezterm";

    xdg.configFile."opencode/opencode.json".text = lib.mkIf pkgs.stdenv.isDarwin (builtins.toJSON {
      "$schema" = "https://opencode.ai/config.json";
      plugin = [ "opencode-antigravity-auth@latest" ];
      provider = {
        google = { models = { "antigravity-gemini-3-pro" = { name = "Gemini 3 Pro"; }; }; };
      };
    });
  };
}
