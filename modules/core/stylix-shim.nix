{ lib, ... }:
{
  options.programs.neovim.initLua = lib.mkOption {
    type = lib.types.lines;
    default = "";
    internal = true;
    description = "Shim for stylix neovide.nix compatibility";
  };

  options.qt.qt5ctSettings = lib.mkOption {
    type = lib.types.attrsOf (lib.types.attrsOf lib.types.anything);
    default = {};
    internal = true;
  };

    options.qt.qt6ctSettings = lib.mkOption {
    type = lib.types.attrsOf (lib.types.attrsOf lib.types.anything);
    default = {};
    internal = true;
  };
}