{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.myConfig.dev.tools.sesh;
  inherit (config.myConfig) dotfilesPath;
  symlink = config.lib.file.mkOutOfStoreSymlink;
  tmuxinatorDir = ./../../dotfiles/tmux/tmuxinator; # path relative tới file sesh.nix
in {
  options.myConfig.dev.tools.sesh = {
    enable = lib.mkEnableOption "Enable Sesh tmux session manager";
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      sesh
    ];
    xdg.configFile =
      {
        "sesh/sesh.toml".source = symlink "${dotfilesPath}/sesh/sesh.toml";
      }
      // lib.mapAttrs' (name: _:
        lib.nameValuePair "tmuxinator/${name}" {
          source = symlink "${dotfilesPath}/tmux/tmuxinator/${name}";
        })
      (builtins.readDir tmuxinatorDir);
  };
}
