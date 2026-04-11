{
  config,
  lib,
  ...
}: let
  cfg = config.myConfig.terminal.shells;
  inherit (config.myConfig) dotfilesPath;

  nushellConfigDir = "${dotfilesPath}/nushell/.config/nushell";
  fishConfigDir = "${dotfilesPath}/fish/.config/fish";

  # Path type for Starship (Flake pure mode compatible)
  starshipConfigPath = ../../dotfiles/starship/.config/starship.toml;

  symlink = config.lib.file.mkOutOfStoreSymlink;
in {
  options.myConfig.terminal.shells = {
    enable = lib.mkEnableOption "Enable Fish, Nushell, and Starship shells";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      fish.enable = true;
      nushell.enable = true;

      starship = {
        enable = true;
        settings = fromTOML (builtins.readFile starshipConfigPath);
      };
    };

    xdg.configFile = {
      # --- Fish ---
      # We use mkForce here to tell Nix: "Ignore the default fish module's file, use my symlink!"
      "fish/config.fish".source = lib.mkForce (symlink "${fishConfigDir}/config.fish");
      "fish/functions".source = symlink "${fishConfigDir}/functions";

      # --- Nushell ---
      "nushell/config.nu".source = symlink "${nushellConfigDir}/nushell/config.nu";
      "nushell/env.nu".source = symlink "${nushellConfigDir}/nushell/env.nu";
      "nushell/systems".source = symlink "${nushellConfigDir}/nushell/systems";
      "nushell/utils".source = symlink "${nushellConfigDir}/nushell/utils";
    };
  };
}
