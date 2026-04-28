{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.myConfig.dev.tools.cli;
in {
  options.myConfig.dev.tools.cli = {
    enable = lib.mkEnableOption "Enable CLI visualization utilities";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      bottom # htop
      procs # ps
      dust # du
      bat
      jq
      bc
      fd
      ripgrep
      fzf
      eza # ls
      git
      lazygit
      lazydocker
      delta
      duf
    ];

    programs.zoxide = {
      enable = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
      options = [
        "--cmd cd"
      ];
    };
  };
}
