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
[Tmux] C-a + C-b    | Break Pane (Convert current pane to a new window)
[Tmux] Alt + Space  | Floating Terminal (No Prefix required)
[Tmux] Alt + g      | Lazygit Popup (No Prefix required)
[Tmux] Alt + t      | Television Search Popup (No Prefix required)

## 🗄️ Tmux Tools (Utilities)
[Tmux] tsn [name]   | Create or Switch to session [name]
[Tmux] tsa [name]   | Attach/Switch to existing session
[Tmux] tsk [name]   | Kill session [name]
[Tmux] tsr [name]   | Rename current session to [name]
[Tmux] twn [name]   | Create new window named [name]
[Tmux] twr [name]   | Rename current window to [name]
[Tmux] tss          | Full sync and reload tmux environment

## 🚀 AeroSpace - Window Management (Alt = Option)
[Aero] Alt + h/j/k/l | Focus Left / Down / Up / Right
[Aero] Alt + f      | Toggle Fullscreen
[Aero] Alt + \      | Layout: Tiles (Horizontal/Vertical)
[Aero] Alt + =      | Layout: Accordion
[Aero] Alt + Shift + h/j/k/l | Move window Left/Down/Up/Right
[Aero] Alt + Shift + -/=     | Resize window smaller/larger
[Aero] Alt + Shift + ;       | ENTER SERVICE MODE (Reload, Float, Join)

## 🌌 AeroSpace - Workspaces (Alt + Key)
[Aero] Alt + 1      | [C] Coding
[Aero] Alt + 2      | [B] Browser
[Aero] Alt + 3      | [V] Video / VM
[Aero] Alt + 4      | [D] Document / Finder
[Aero] Alt + 5      | [G] Gaming
[Aero] Alt + 6      | [M] Music
[Aero] Alt + a      | [A] Applications (Docker, Postman)
[Aero] Alt + n      | [N] Notes (Obsidian, Notion)
[Aero] Alt + r      | [R] Reading (Preview, PDF)
[Aero] Alt + s      | [S] Settings / System
[Aero] Alt + t      | [T] Terminal
[Aero] Alt + w      | [W] Work (Slack, Discord)
[Aero] Alt + x      | [X] Experimental / VM

## ❄️ Nix System Commands
[Nix] nixss          | System Rebuild & Switch (Darwin/Linux)
[Nix] nix-list       | List all system generations
[Nix] nix-current    | Show active system generation
[Nix] nix-back [no]  | Rollback to a specific generation
[Nix] nix-test [pkg] | Test a package in a temporary shell

## 🛠️ Nix Development Workflow (Project Level)
[Nix] nix-init       | Setup Dev Env (Stealth mode using git-exclude)
[Nix] nix-purge      | Fully wipe local Nix env and restore git state
[Nix] nix-publish    | Promote private Nix config to repository (Public)
[Nix] nix-unpublish  | Revert public Nix config back to Private/Stealth

## 📂 Fast Navigation
[Go] ncf             | Jump to Nix Config base directory
[Go] fcf / vcf / tcf | Jump to Fish / Neovim / Tmux configs
[Go] wcf / acf / lzcf| Jump to Wezterm / AeroSpace / Lazygit configs
[Go] pcf             | Jump to main Projects directory

## 🎣 Fish & Git Utils
[Fish] ss            | Reload Fish shell configuration
[Fish] ls [level]    | Enhanced directory listing (eza). Use 1-9 for Tree view
[Git]  git-rescue    | EMERGENCY: Recover uncommitted local changes
[Git]  git-toggle    | Toggle Delta's side-by-side diff mode

## 📺 Television Channels
[TV] tv files        | Search for files
[TV] tv git-repos    | Search for Git projects
[TV] tv text         | Global text search (Grep)
[TV] tv env          | Search environment variables

## 🎨 Rio Terminal - Advanced Hints
[Rio] Ctrl + Shift + o     | URL Hint: Open links in browser
[Rio] Ctrl + Shift + f     | File Hint: Open path in Neovim (Tmux split)
[Rio] Ctrl + Shift + g     | Git Hint: Copy commit SHA to clipboard
[Rio] Ctrl + Shift + l     | Localhost Hint: Open dev server links