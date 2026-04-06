{ config, pkgs, lib, ... }:

let
  cfg = config.myConfig.dev.tools.web;
in
{
  options.myConfig.dev.tools.web = {
    enable = lib.mkEnableOption "Enable Web Development environment (PHP, NodeJS)";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      nodejs_22 
      php82 php82Packages.composer php82Packages.php-codesniffer
    ];
  };
}
