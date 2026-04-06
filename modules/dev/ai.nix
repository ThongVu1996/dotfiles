{ config, pkgs, lib, ... }:

let
  cfg = config.myConfig.dev.tools.ai;
in
{
  options.myConfig.dev.tools.ai = {
    enable = lib.mkEnableOption "Enable AI tools (Claude Code, OpenCode)";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      claude-code
    ] ++ lib.optionals pkgs.stdenv.isDarwin [
      opencode
    ];

    xdg.configFile."opencode/opencode.json".text = lib.mkIf pkgs.stdenv.isDarwin (builtins.toJSON {
      "$schema" = "https://opencode.ai/config.json";
      plugin = [ "opencode-antigravity-auth@latest" ];
      provider = {
        google = { models = { "antigravity-gemini-3-pro" = { name = "Gemini 3 Pro"; }; }; };
      };
    });
  };
}
