# ⌨️ SYSTEM & WORKFLOW CHEATSHEET

## 🟢 Tmux General (Prefix: Ctrl + a)
[Tmux] C-a + r      | Reload tmux configuration
[Tmux] C-a + m      | Toggle Zoom Pane (Fullscreen/Restore)
[Tmux] C-a + \      | Split Pane Horizontal
[Tmux] C-a + -      | Split Pane Vertical
[Tmux] C-a + x      | Kill current pane
[Tmux] C-a + ?      | Open Television Cheatsheet (Custom)
[Tmux] C-h/j/k/l    | Smart Navigation (Switch between Vim & Tmux panes)
[Tmux] C-a + h/j/k/l| Resize current pane (Repeatable)
[Tmux] C-a + C-j    | Join Pane (Horizontal)
[Tmux] C-a + C-k    | Join Pane (Vertical)
[Tmux] C-a + C-b     | Break Pane (Tách cửa sổ ra thành tab mới)
[Tmux] Alt + Space   | Floating Terminal (Mở terminal nổi - Không cần Prefix)
[Tmux] Alt + g       | Lazygit Popup (Quản lý Git nổi - Không cần Prefix)
[Tmux] Alt + t       | Television Popup (Tìm kiếm trung tâm nổi - Không cần Prefix)

## 🗄️ Tmux Tools (Utilities)
[Tmux] tsn [name]    | Create or Switch to session [name]
[Tmux] tsa [name]    | Attach/Switch to existing session
[Tmux] tsk [name]    | Kill session [name]
[Tmux] tsr [name]    | Rename current session to [name]
[Tmux] twn [name]    | Create new window named [name]
[Tmux] twr [name]    | Rename current window to [name]
[Tmux] tss           | Reload tmux configuration

## 🚀 AeroSpace - Window Management (Alt = Option)
[Aero] Alt + h/j/k/l | Focus Left / Down / Up / Right
[Aero] Alt + f      | Toggle Fullscreen
[Aero] Alt + \      | Layout: Tiles (Horizontal/Vertical)
[Aero] Alt + =      | Layout: Accordion
[Aero] Alt + Shift + h/j/k/l | Move window Left/Down/Up/Right
[Aero] Alt + Shift + -/=     | Resize window smaller/larger
[Aero] Alt + Shift + ;       | ENTER SERVICE MODE (Reload, Float, Join)

## 🌌 AeroSpace - Workspaces (Alt + Key)
[Aero] Alt + 1      | [C] Coding (Ghostty)
[Aero] Alt + 2      | [B] Browser (Chrome, Safari, Edge,...)
[Aero] Alt + 3      | [V] Video/VM (DaVinci, VMware)
[Aero] Alt + 4      | [D] Document/Finder
[Aero] Alt + 5      | [G] Game
[Aero] Alt + 6      | [M] Music
[Aero] Alt + a      | [A] Any (Docker, Postman)
[Aero] Alt + n      | [N] Notes (Obsidian, Notion)
[Aero] Alt + r      | [R] Reading (Preview, Sioyek)
[Aero] Alt + s      | [S] Setting (iTerm2)
[Aero] Alt + t      | [T] Terminal
[Aero] Alt + w      | [W] Work (Slack, Discord)
[Aero] Alt + x      | [X] VM Enjoy

## 🛠️ Nix Commands
[Nix] nixss          | Build & Switch (Darwin/Linux)
[Nix] nix-list       | List all generations
[Nix] nix-current    | Show active generation
[Nix] nix-back [no]  | Rollback to generation X
[Nix] nix-test [pkg] | Test package in temporary shell

## 🎣 Fish & Git Utils
[Fish] ss            | Reload Fish configuration
[Fish] ls [level]    | List files (eza). If number provided (1-9): Show Tree view
[Git]  git-rescue    | RESCUE: Recover uncommitted code (emergency)
[Git]  git-toggle    | Toggle Delta's side-by-side mode (Diffing)

## 📂 Fast Navigation
[Go] ncf             | Jump to Nix Config directory
[Go] fcf / vcf / tcf | Jump to Fish / Neovim / Tmux config
[Go] wcf / acf / lzcf| Jump to Wezterm / AeroSpace / Lazygit config
[Go] pcf             | Jump to Project directory

## 📺 Television Channels
[TV] tv files        | Find files
[TV] tv git-repos    | Find git projects
[TV] tv text         | Search content (Grep)
[TV] tv env          | Search environment variables