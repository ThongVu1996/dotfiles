{ config, pkgs, lib, ... }:

let
  cfg = config.myConfig.terminal.shells;
  dotfilesPath = config.myConfig.dotfilesPath;
  nushellConfigDir   = "${dotfilesPath}/nushell/.config/nushell";
  fishConfigDir      = "${dotfilesPath}/fish/.config/fish";
  # Định nghĩa các Path tương đối (Path type) để không bị lỗi Pure Mode
  starshipConfigPath = ../../dotfiles/starship/.config/starship.toml;
in
{
  options.myConfig.terminal.shells = {
    enable = lib.mkEnableOption "Enable Fish, Nushell, and Starship shells";
  };

  config = lib.mkIf cfg.enable {
    # 1. Starship: Dùng programs để Stylix có thể "tiêm" màu vào
    programs.starship = {
      enable = true;
      settings = builtins.fromTOML (builtins.readFile starshipConfigPath);
    };

    # 2. Direnv: Quản lý môi trường
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    # 3. Các Shell khác và Symlinks
    home.packages = with pkgs; [
      fish
      nushell
    ];

    xdg.configFile = {
      "fish/config.fish".source = config.lib.file.mkOutOfStoreSymlink "${fishConfigDir}/config.fish";
      "fish/functions".source   = config.lib.file.mkOutOfStoreSymlink "${fishConfigDir}/functions";

      "nushell/config.nu".source = config.lib.file.mkOutOfStoreSymlink "${nushellConfigDir}/config.nu";
      "nushell/env.nu".source    = config.lib.file.mkOutOfStoreSymlink "${nushellConfigDir}/env.nu";
      "nushell/systems".source   = config.lib.file.mkOutOfStoreSymlink "${nushellConfigDir}/systems";
      "nushell/utils".source     = config.lib.file.mkOutOfStoreSymlink "${nushellConfigDir}/utils";
    };
  };
}