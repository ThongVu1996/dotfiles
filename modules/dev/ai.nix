{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.myConfig.dev.tools.ai;
in {
  options.myConfig.dev.tools.ai = {
    enable = lib.mkEnableOption "Enable AI tools (Claude Code, OpenCode)";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs;
      [
        claude-code
      ]
      ++ lib.optionals pkgs.stdenv.isDarwin [
        opencode
      ];
  };
}
