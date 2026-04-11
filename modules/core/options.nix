{
  config,
  lib,
  ...
}: {
  options.myConfig.dotfilesPath = lib.mkOption {
    type = lib.types.str;
    default = "${config.home.homeDirectory}/nix-config/dotfiles";
    description = "Absolute path to the dotfiles directory within the nix-config repository";
  };
}
