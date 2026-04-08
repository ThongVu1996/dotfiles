{ config, pkgs, lib, ... }:

let
  cfg = config.myConfig.terminal.emulators;
  weztermLuaPath = ../../dotfiles/wezterm/.config/wezterm/wezterm.lua;
in
{
  options.myConfig.terminal.emulators = {
    enable = lib.mkEnableOption "Enable Terminal Emulators (Wezterm, Rio)";
  };

  config = lib.mkIf cfg.enable {
    programs.wezterm = {
      enable = true;
      extraConfig = builtins.readFile weztermLuaPath;
    };
  };
}