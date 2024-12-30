
# Dotfiles Repository

This repository contains my personal configuration files (dotfiles) for tools and environments I use daily. These dotfiles are organized for efficient management using [GNU Stow](https://www.gnu.org/software/stow/).

---

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
- **`fish/`**: Configuration for [Fish](https://fishshell.com).

---

## 🛠️ Prerequisites

Before using these dotfiles, ensure the following tools are installed:

### Install Homebrew

```bash
sudo apt update
sudo apt install build-essential curl file git -y
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Add PATH of Homebrew to bash shell:

```bash
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
```

### Install Nerd Font (Default: Hack Nerd Font)

```bash
git clone https://github.com/ryanoasis/nerd-fonts.git
cd nerd-fonts
./install.sh Hack
```

---

## 🚀 Installation

### Clone the repository

```bash
git clone git@github.com:ThongVu1996/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### Install other applications by BrewFile

```bash
brew bundle --file=Brewfile
```

> **Note**: If you use WSL in Windows, you must install WezTerm in Windows. Do not use WezTerm installed by brew.

### Create BrewFile (optional)

```bash
brew bundle dump --file=Brewfile
```

### Update BrewFile

```bash
brew bundle dump --force --file=Brewfile
```

---

## 🐟 Use Fish Shell

```bash
echo /usr/bin/fish | sudo tee -a /etc/shells
chsh -s /usr/bin/fish
fish
```

### Remove file config.fish (eg: ~/.config/fish/config.fish or ~/.config/config.fish)
Create symlink

```bash
ln -s ~/dotfiles/fish/.config/fish/config.fish ~/.config/fish/config.fish
source ~/.config/fish/config.fish
```

> **Note**: Close and reopen the terminal.

---

## 📋 Apply configurations using GNU Stow

### Apply configurations

```bash
stow tmux
stow nvim
stow wezterm -- Don't need if you use wsl
```

### Remove configurations

If you want to remove a configuration, use:

```bash
stow -D <folder_name>
```

Example:

```bash
stow -D tmux
```

---

## 🖼️ Screenshots

Here’s how my terminal looks after applying these configurations:

- **Neovim:**
  ![Neovim Screenshot](images/nvim.png)

- **WezTerm:**
  ![WezTerm Screenshot](images/wezterm.png)

- **Tmux:**
  ![Tmux Screenshot](images/tmux.png)

---

## ✨ Features

- Simplified dotfiles management using GNU Stow.
- Easy to customize and extend for other tools.
- Supports configurations for tmux, Neovim, Git, and Zsh.

---

## 🐧 WSL Configuration

### Fix Date and Time
#### Open comment setting  ram, cpu for wsl in file .tmux.conf. Commend ram,cpu for native linux 
Set Windows to Use Local Time:

```bash
sudo timedatectl set-timezone your_time_zone
```

Example

```bash
sudo timedatectl set-timezone America/New_York
```

or 
```bash
sudo timedatectl set-timezone Asia/Ho_Chi_Minh
```


Restart your computer.

Verify Time in WSL:

```bash
date
```

### Display CPU and RAM Usage

Install Required Tools:

```bash
sudo apt update
sudo apt install sysstat procps
```

Create Scripts for CPU and RAM Usage:

#### CPU Usage Script

```bash
echo '#!/bin/bash
top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk "{print int(100 - \$1)}"' > ~/.tmux/cpu_usage.sh
chmod +x ~/.tmux/cpu_usage.sh
```

#### RAM Usage Script

```bash
echo '#!/bin/bash
free | grep Mem | awk "{print int(\$3/\$2 * 100.0)}"' > ~/.tmux/ram_usage.sh
chmod +x ~/.tmux/ram_usage.sh
```

Update `tmux.conf`:

```bash
set -g status-right "#(~/.tmux/cpu_usage.sh)% CPU | #(~/.tmux/ram_usage.sh)% RAM | %H:%M"
```

Reload tmux Configuration:

```bash
tmux source-file ~/.tmux.conf
```

---

## 📖 References

- [GNU Stow Documentation](https://www.gnu.org/software/stow/)
- [tmux GitHub Repository](https://github.com/tmux/tmux)
- [Neovim Documentation](https://neovim.io/)
- [Fish Documentation](https://fishshell.com)

---

## 🤝 Contributing

Contributions are welcome! Feel free to fork this repository and submit a pull request with your improvements.

---

## 📝 License

This project is licensed under the MIT License. See the LICENSE file for details.
