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
      default = 3.0;
    };
    active_color = lib.mkOption {
      type = lib.types.str;
      default = "gradient(top_right=0xff8aadf4,bottom_left=0xffc6a0f6)";
    };
    inactive_color = lib.mkOption {
      type = lib.types.str;
      default = "0xff313244";
    };
    style = lib.mkOption {
      type = lib.types.str;
      default = "round";
    };
    blur_radius = lib.mkOption {
      type = lib.types.float;
      default = 10.0;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.jankyborders];
  };
}
