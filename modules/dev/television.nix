{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.myConfig.dev.tools.television;
  inherit (config.myConfig) dotfilesPath;
  inherit (config.lib.stylix) colors;
  symlink = config.lib.file.mkOutOfStoreSymlink;
  cableDir = ../../dotfiles/television/cable;
in {
  options.myConfig.dev.tools.television = {
    enable = lib.mkEnableOption "Enable Television fuzzy finder";
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      television
    ];
    xdg.configFile =
      {
        "television/config.toml".text = ''
          ${builtins.readFile ../../dotfiles/television/config.toml}
          [ui.colors]
          border = "#${colors.base0D}"
          selection_bg = "#${colors.base02}"
          selection_fg = "#${colors.base0B}"
          match_fg = "#${colors.base09}"
          dimmed_fg = "#${colors.base03}"
        '';
      }
      // lib.mapAttrs' (name: _:
        lib.nameValuePair "television/cable/${name}" {
          source = symlink "${dotfilesPath}/television/cable/${name}";
        })
      (builtins.readDir cableDir);
  };
}
