{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.myConfig.dev.tools.devops;
in {
  options.myConfig.dev.tools.devops = {
    enable = lib.mkEnableOption "Enable CI/CD, DevOps, and Cloud tools";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs;
      [
        tailscale
        awscli2
        eksctl
        kubernetes-helm
        argocd
        cloud-nuke
        terraform
        python315
        pkg-config
        terraform-ls
        tflint
        gh
        cloudflared
        vault
        ansible
        lazyssh
      ]
      ++ lib.optionals pkgs.stdenv.isDarwin [
        orbstack # replace docker kubectl for macos
      ]
      ++ lib.optionals pkgs.stdenv.isLinux [
        docker
        kubectl
      ];
  };
}
