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

      fish = {
        enable = true;
        interactiveShellInit = ''
          # Load custom config from dotfiles
          source ${fishConfigDir}/config.fish
        '';
        shellAliases = {
          # Core Tools
          vi = "nvim";
          ls = "eza --icons --group-directories-first";
          ll = "eza -lh --icons --git --group-directories-first";
          la = "eza -la --icons --git --group-directories-first";
          cat = "bat --style=plain";
          top = "btm";
          ps = "procs";
          du = "dust";

          # Utils
          lz = "lazygit";
          lg = "lazydocker";
          f = "fzf";
          fp = "fzf --preview='bat --color=always {}'";
          fv = "nvim (fzf -m --preview='bat --color=always {}')";
        };
        shellAbbrs = {
          # Quick Config Navigation
          ncf = "cd ~/nix-config";
          pcf = "cd ~/Project/";
          fcf = "cd ~/nix-config/dotfiles/fish/.config/fish && echo 'You can configure Fish'";
          vcf = "cd ~/nix-config/dotfiles/nvim/.config/nvim && echo 'You can configure Neovim'";
          tcf = "cd ~/nix-config/dotfiles/tmux && echo 'You can configure Tmux'";
          scf = "cd ~/nix-config/dotfiles/starship/ && echo 'You can configure Starship'";
          wcf = "cd ~/nix-config/dotfiles/wezterm/.config/wezterm";
          acf = "cd ~/nix-config/dotfiles/aerospace/.config/aerospace";
          lzcf = "cd ~/nix-config/dotfiles/lazygit/.config/lazygit";
        };
      };
      nushell.enable = true;

      starship = {
        enable = true;
        settings = fromTOML (builtins.readFile starshipConfigPath);
      };
    };

    xdg.configFile = {
      # --- Fish ---
      "fish/functions".source = symlink "${fishConfigDir}/functions";
      "fish/conf.d/aliases.fish".source = symlink "${fishConfigDir}/conf.d/aliases.fish";

      # --- Nushell ---
      "nushell/config.nu".source = symlink "${nushellConfigDir}/nushell/config.nu";
      "nushell/env.nu".source = symlink "${nushellConfigDir}/nushell/env.nu";
      "nushell/systems".source = symlink "${nushellConfigDir}/nushell/systems";
      "nushell/utils".source = symlink "${nushellConfigDir}/nushell/utils";
    };
  };
}
