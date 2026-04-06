{ config, pkgs, lib, ... }:

let
  cfg = config.myConfig.desktop.apps;
in
{
  options.myConfig.desktop.apps = {
    enable = lib.mkEnableOption "Bật các ứng dụng Desktop cơ bản (KeePassXC...)";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      keepassxc
    ];
  };
}
