{ config, lib, ... }:

{
  options.myConfig.dotfilesPath = lib.mkOption {
    type = lib.types.str;
    default = "${config.home.homeDirectory}/nix-config/dotfiles";
    description = "Đường dẫn tuyệt đối tới thư mục dotfiles trong repo nix-config";
  };
}
