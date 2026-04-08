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
    programs.tmux = {
      enable = true;
      extraConfig = ''
        source-file ${dotfilesPath}/tmux/.tmux.conf
      '';
    };
  };
}