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
      # "Tiêm" đường dẫn ảnh từ Nix vào code Lua
      extraConfig = ''
        local nix_bg_path = "${../../dotfiles/wezterm/.config/wezterm/bg/bg.jpg}"
        ${builtins.readFile weztermLuaPath}
      '';
    };
  };
}