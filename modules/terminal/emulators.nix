{ config, pkgs, lib, ... }:

let
  cfg = config.myConfig.terminal.emulators;
  dotfilesPath = config.myConfig.dotfilesPath;
in
{
  options.myConfig.terminal.emulators = {
    enable = lib.mkEnableOption "Enable Terminal Emulators (Wezterm, Rio)";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      wezterm
    ] ++ lib.optionals pkgs.stdenv.isDarwin [
      rio
    ];

    xdg.configFile."rio/config.toml".source = lib.mkIf pkgs.stdenv.isDarwin (config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/rio/.config/rio/config.toml");
    xdg.configFile."wezterm".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/wezterm/.config/wezterm";
  };
}
