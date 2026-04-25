{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.myConfig.desktop.skhd;
in {
  options.myConfig.desktop.skhd = {
    enable = lib.mkEnableOption "Enable SKHD (Simple Hotkey Daemon) via Home Manager";
  };

  config = lib.mkIf cfg.enable {
    # skhd only runs on macOS
    home.packages = lib.optionals pkgs.stdenv.isDarwin [
      pkgs.skhd
    ];

    # Services management via Home Manager (User Launch Agent)
    services.skhd = lib.mkIf pkgs.stdenv.isDarwin {
      enable = true;
      package = pkgs.skhd;
      config = builtins.readFile ../../dotfiles/skhd/skhdrc;
    };
  };
}
