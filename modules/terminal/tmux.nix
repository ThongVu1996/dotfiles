{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myConfig.terminal.tmux;
  inherit (config.myConfig) dotfilesPath;
in {
  options.myConfig.terminal.tmux = {
    enable = lib.mkEnableOption "Enable Tmux (cross-platform)";
  };

  config = lib.mkIf cfg.enable {

    home.packages = with pkgs; [
      tmuxinator
    ];

    programs.tmux = {
      enable = true;
      extraConfig = ''
        source-file ${dotfilesPath}/tmux/.tmux.conf
      '';
    };
  };
}
