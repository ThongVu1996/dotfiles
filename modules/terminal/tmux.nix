{ config, pkgs, lib, ... }:

let
  cfg = config.myConfig.terminal.tmux;
  dotfilesPath = config.myConfig.dotfilesPath;
in
{
  options.myConfig.terminal.tmux = {
    enable = lib.mkEnableOption "Enable Tmux (cross-platform)";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      tmux
    ];

    home.file.".tmux.conf".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/tmux/.tmux.conf";
  };
}
