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

## ⌨️ Kanata - Keyboard Remap (Home Row Mods & Layers)
[Kanata] CapsLock (Tap) | Escape
[Kanata] g (Hold)        | Numeric Layer (uio=789, jkl=456, m,.=123, n=0, h=.)
[Kanata] v (Hold)        | Navigation Layer (hjkl: Phím mũi tên ←↓↑→)
[Kanata] Space (Hold)    | Mouse, Tmux & Cmd Layer (hjkl: Mouse Move)
[Kanata] c (Hold)        | Media Layer (hjkl: Âm lượng/Độ sáng)
[Kanata] b (Hold)        | Symbols Layer (&*($%^!@#)
[Kanata] d + f (Chord)   | Escape (Fast exit for Vim)
[Kanata] j + k (Chord)   | Backspace
[Kanata] k + l (Chord)   | Enter
[Kanata] c + v (Chord)   | Tab
[Kanata] m + , (Chord)   | Shift + Tab
[Kanata] x + c (Chord)   | Clear Terminal (Type 'clear' + Enter)

## 🎛️ Kanata - Mouse, Media, Sym & Num Details
[Kanata] Space + h/j/k/l | Mouse: Left / Down / Up / Right (Vim Move) 🖱️
[Kanata] Space + u / i / o | Clicks: Left Click / Middle Click / Right Click 🖱️
[Kanata] Space + ; / '   | History: Back / Next trang (Browser) 🔄
[Kanata] Space + n / m   | AeroSpace: Workspace N / M
[Kanata] Space + , / .   | Scroll: Cuộn xuống / Cuộn lên ↕️
[Kanata] v + h / j / k / l | Navigation: Phím mũi tên ← ↓ ↑ →
[Kanata] c + h / l       | Brightness Down / Up ☀️
[Kanata] c + j / k       | Volume Down / Up 🔊
[Kanata] b + u / i / o   | Symbols: & * (
[Kanata] b + j / k / l   | Symbols: $ % ^
[Kanata] b + n / m / , / . | Symbols: ) ! @ #
[Kanata] b + p           | Play / Pause Music ⏸️
[Kanata] g + u / i / o   | Numbers: 7 8 9
[Kanata] g + j / k / l   | Numbers: 4 5 6
[Kanata] g + n / m / , / . | Numbers: 0 1 2 3

## 🎯 Kanata - Space Layer (Context Aware & Workflow)
Lớp **Space Layer** không chỉ đóng vai trò di chuột, mà còn là luồng làm việc "Nhận diện ngữ cảnh" (Context-Aware) thông minh qua `skhd_dispatcher.sh`.

- [Kanata] Spc + h/j/k/l   | Mouse: Di chuyển chuột (Smooth Move)
- [Kanata] Spc + ;/'       | Browser: Back / Next trang 🔄
- [Kanata] Spc + c/b/w/n/m | AeroSpace: Code / Browser / Work / Notes / Media

**🖥️ Context-Aware Keys (Chỉ ở Terminal Rio -> Tmux, Còn lại -> Hành động Toàn cầu):**
- [Kanata] Spc + s         | Rio: Split Ngang Tmux   / Toàn cầu: Save (Cmd + S) 💾
- [Kanata] Spc + v         | Rio: Split Dọc Tmux     / Toàn cầu: Save (Cmd + S) 💾
- [Kanata] Spc + z         | Rio: Zoom Toggle Tmux 
- [Kanata] Spc + x         | Rio: Kill Pane Tmux     
- [Kanata] Spc + g         | Rio: Bật Session List Tmux

**⚡ Lệnh Hệ Thống Toàn Cầu (Giữ Space):**
- [Kanata] Spc + q         | Quit App: Cmd + Q ❌
- [Kanata] Spc + a         | Select All: Cmd + A

## ⚡ Kanata - Hyper Layer (Hold CapsLock + Key)
[Kanata] Hyper + a/b/t/e  | System: Lệnh Raycast / Skhd (Hyper + key)
[Kanata] Hyper + q/w/x    | Neovim: Save & Quit / Save All / Quit No Save
[Kanata] Hyper + f        | Neovim: Global Search (/)