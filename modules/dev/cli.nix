{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.myConfig.dev.tools.cli;
  myDuf = pkgs.callPackage ../../modules/custom/duf.nix {};
in {
  options.myConfig.dev.tools.cli = {
    enable = lib.mkEnableOption "Enable CLI visualization utilities";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      btop
      bat
      jq
      fd
      ripgrep
      fzf
      eza
      myDuf
    ];
  };
}
