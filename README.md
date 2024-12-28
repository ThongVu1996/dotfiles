# Dotfiles Repository

This repository contains my personal configuration files (dotfiles) for tools and environments I use daily. These dotfiles are organized for efficient management using [GNU Stow](https://www.gnu.org/software/stow/).

## 📂 Repository Structure

The repository is organized as follows:

```plaintext
dotfiles/
├── tmux/
│   └── .tmux.conf
├── nvim/
│   └── .config/nvim/init.lua
├── git/
│   └── .gitconfig
├── fish/
│   └── .config/fish/config.fish
```

- **`tmux/`**: Configuration for [tmux](https://github.com/tmux/tmux).
- **`nvim/`**: Configuration for [Neovim](https://neovim.io/).
- **`git/`**: Global Git configurations.
- **`zsh/`**: Configuration for [Zsh](https://www.zsh.org/).

## 🛠️ Prerequisites

Before using these dotfiles, ensure the following tools are installed:

- **GNU Stow**: For managing symlinks.
- Relevant applications (`tmux`, `neovim`, `fish`, etc.).

## 🚀 Installation

Follow these steps to set up your dotfiles:

### Clone the repository

```bash
git clone git@github.com:ThongVu1996/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### Apply configurations using GNU Stow

Run the following commands for the desired tools:

```shell
stow tmux
stow nvim
stow git
stow fish
```

This creates symlinks in your home directory, pointing to the respective configuration files in the repository.

### Remove configurations

If you want to remove a configuration, use:

```bash
stow -D <folder_name>
```

For example:

```bash
stow -D tmux
```

## 📋 Usage

### Add new configurations

1. Create a new folder in the `dotfiles` directory.
2. Add configuration files to the folder, mirroring the structure of `$HOME`.
3. Use `stow <folder_name>` to apply the new configuration.

### Update configurations

1. Edit the configuration files directly in the `dotfiles` repository.
2. Commit and push changes to the repository for backup.

## 🖼️ Screenshots

Here’s how my terminal looks after applying these configurations:

- **Neovim:**
  ![Neovim Screenshot](images/nvim.png)

- **Wezterm:**
  ![Wezterm Screenshot](images/wezterm.png)

- **Tmux:**
  ![Tmux Screenshot](images/tmux.png)

## ✨ Features

- Simplified dotfiles management using GNU Stow.
- Easy to customize and extend for other tools.
- Supports configurations for tmux, Neovim, Git, and Zsh.

## 📖 References

- [GNU Stow Documentation](https://www.gnu.org/software/stow/)
- [tmux GitHub Repository](https://github.com/tmux/tmux)
- [Neovim Documentation](https://neovim.io/)
- [Zsh Documentation](https://www.zsh.org/)

## 🤝 Contributing

Contributions are welcome! Feel free to fork this repository and submit a pull request with your improvements.

## 📝 License

This project is licensed under the MIT License. See the `LICENSE` file for details.
