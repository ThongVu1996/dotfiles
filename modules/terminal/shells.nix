{ config, pkgs, lib, ... }:

let
  cfg = config.myConfig.terminal.shells;
  dotfilesPath = config.myConfig.dotfilesPath;
  nushellConfigPath = "${dotfilesPath}/nushell/.config/nushell";
in
{
  options.myConfig.terminal.shells = {
    enable = lib.mkEnableOption "Bật Fish, Nushell, Starship";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      fish
      nushell
      starship
      direnv
    ];

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    xdg.configFile = {
      "starship.toml".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/starship/.config/starship.toml";
      
      # Out of store symlinks (Editable configs)
      "fish/config.fish".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/fish/.config/fish/config.fish";
      "fish/functions".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/fish/.config/fish/functions";

      # Nushell Configs
      "nushell/config.nu".source = config.lib.file.mkOutOfStoreSymlink "${nushellConfigPath}/config.nu";
      "nushell/env.nu".source    = config.lib.file.mkOutOfStoreSymlink "${nushellConfigPath}/env.nu";
      "nushell/systems".source   = config.lib.file.mkOutOfStoreSymlink "${nushellConfigPath}/systems";
      "nushell/utils".source     = config.lib.file.mkOutOfStoreSymlink "${nushellConfigPath}/utils";
    };
  };
}
