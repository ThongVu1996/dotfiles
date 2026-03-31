{ config, pkgs, lib, ... }:

let
  cfg = config.myConfig.dev.tools.devops;
in
{
  options.myConfig.dev.tools.devops = {
    enable = lib.mkEnableOption "Bật các công cụ CI/CD, DevOps và Cloud";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      tailscale awscli2 eksctl kubectl 
      kubernetes-helm argocd cloud-nuke 
      terraform python315 pkg-config 
      terraform-ls tflint gh cloudflared
      vault ansible docker
    ];
  };
}
