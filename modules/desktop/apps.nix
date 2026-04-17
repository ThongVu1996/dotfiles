{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.myConfig.desktop.apps;
in {
  options.myConfig.desktop.apps = {
    enable = lib.mkEnableOption "Enable basic Desktop applications (KeePassXC, etc.)";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs;
      [
        keepassxc
        discord
        antigravity
      ]
      ++ lib.optionals pkgs.stdenv.isDarwin [
        # dockDoor
        wifi-unredactor
      ];
  };
}
