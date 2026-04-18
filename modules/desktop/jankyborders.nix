{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.myConfig.desktop.jankyborders;
in {
  options.myConfig.desktop.jankyborders = {
    enable = lib.mkEnableOption "Enable JankyBorders";
    width = lib.mkOption {
      type = lib.types.float;
      default = 6.0;
    };
    active_color = lib.mkOption {
      type = lib.types.str;
      default = "0xffe1e1e1";
    };
    inactive_color = lib.mkOption {
      type = lib.types.str;
      default = "0xff494d64";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.jankyborders];
  };
}
