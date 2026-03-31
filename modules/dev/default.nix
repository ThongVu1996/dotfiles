{ config, pkgs, lib, ... }:

{
  imports = [
    ./devops.nix
    ./cli.nix
    ./web.nix
    ./misc.nix
  ];
}
