# Sketchybar Configuration

Custom Sketchybar configuration with Aerospace window manager integration, inspired by [Felix Kratz's dotfiles](https://github.com/FelixKratz/dotfiles).

## Features

- 🍎 **Apple Menu**: System menu with standard macOS options (Sleep, Restart, Shutdown, Force Quit, etc.)
- 🚀 **Aerospace Integration**: Dynamic workspace display with app icons
- 📱 **Front App Display**: Shows currently focused application with click menu
- 🎨 **Modern Design**: Glassmorphic UI with smooth animations
- ⚡ **Performance Monitoring**: CPU, GPU, RAM, and temperature sensors
- 🔋 **System Status**: Battery, WiFi, volume indicators
- 📅 **Calendar Widget**: Date and time display

## Preview

### Workspace Display
- Active workspace: Red text with app icons in white background pill
- Inactive workspaces: Gray text, no app icons shown
- Smooth animations when switching workspaces

### Layout
```
[Apple] [B 📱 💻] [C] [D] > [App Name] ... [Stats] [Battery] [WiFi] [Volume] [Calendar]
```

## Requirements

- **macOS**: Sonoma or later
- **Nix**: For package management
- **Aerospace**: Window manager ([nikitabobko/AeroSpace](https://github.com/nikitabobko/AeroSpace))
- **Sketchybar**: Status bar ([FelixKratz/SketchyBar](https://github.com/FelixKratz/SketchyBar))
- **SF Pro Font**: System font (pre-installed on macOS)
- **sketchybar-app-font**: For app icons

## Installation

### Quick Install (Recommended)

```bash
cd $HOME/nix-config/dotfiles/sketchybar/.config/sketchybar
chmod +x install.sh
./install.sh
```

### Manual Installation

1. **Add to your Nix configuration** (`home.nix` or `flake.nix`):
   ```nix
   home.packages = with pkgs; [
     sketchybar
     # aerospace  # Install manually or via Homebrew cask
   ];
   
   # Link dotfiles
   home.file.".config/sketchybar".source = ./dotfiles/sketchybar/.config/sketchybar;
   ```

2. **Apply Nix configuration**:
   ```bash
   home-manager switch
   # or if using flakes
   nix build && ./result/activate
   ```

3. **Install Sketchybar App Font**:
   ```bash
   curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v2.0.5/sketchybar-app-font.ttf -o ~/Library/Fonts/sketchybar-app-font.ttf
   ```

4. **Install Aerospace** (not in nixpkgs yet):
   ```bash
   # Via Homebrew
   brew install --cask nikitabobko/tap/aerospace
   # Or download from: https://github.com/nikitabobko/AeroSpace/releases
   ```

5. **Start Sketchybar**:
   ```bash
   sketchybar &
   # Add to your shell startup or use a launch agent
   ```

6. **Grant Permissions**:
   - Go to **System Settings** → **Privacy & Security** → **Accessibility**
   - Add and enable:
     - `$(which sketchybar)` (find path with `which sketchybar`)
     - `/usr/bin/osascript` (for Force Quit functionality)

## Nix Configuration

### For Home Manager (Standalone)

If you're using standalone Home Manager, add this to your `~/.config/home-manager/home.nix`:

```nix
{ config, pkgs, ... }:

{
  # Install Sketchybar package
  home.packages = with pkgs; [
    sketchybar
    # Note: Aerospace is not in nixpkgs yet, install via Homebrew or manually
  ];

  # Link Sketchybar configuration from dotfiles
  home.file.".config/sketchybar" = {
    source = ./dotfiles/sketchybar/.config/sketchybar;
    recursive = true;
  };

  # Optional: Auto-start Sketchybar on login
  # You can also use launchd or add to your shell startup
}
```

Then apply:
```bash
home-manager switch
```

### For NixOS/nix-darwin with Flakes

If you're using a flake-based setup (like nix-darwin), your structure might look like:

**flake.nix**:
```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }: {
    # Your system configuration
    darwinConfigurations.yourHostname = ...;
    
    homeConfigurations.yourUsername = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.aarch64-darwin; # or x86_64-darwin
      modules = [ ./home.nix ];
    };
  };
}
```

**home.nix** (same as above):
```nix
{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    sketchybar
  ];

  home.file.".config/sketchybar" = {
    source = ./dotfiles/sketchybar/.config/sketchybar;
    recursive = true;
  };
}
```

Apply with:
```bash
nix build .#darwinConfigurations.yourHostname.system
./result/sw/bin/darwin-rebuild switch --flake .
# or for home-manager only
home-manager switch --flake .
```

### Verifying Installation

After applying your Nix configuration:

```bash
# Check if Sketchybar is in PATH
which sketchybar
# Should output something like: /nix/store/...-sketchybar-2.x.x/bin/sketchybar

# Check if config is linked
ls -la ~/.config/sketchybar
# Should show a symlink to your dotfiles

# Start Sketchybar
sketchybar &
```

### Auto-start on Login

Add to your shell startup file (`~/.zshrc`, `~/.config/fish/config.fish`, etc.):

```bash
# Start Sketchybar if not already running
if ! pgrep -x "sketchybar" > /dev/null; then
    sketchybar &
fi
```

Or create a launchd plist (more reliable):

```xml
<!-- ~/Library/LaunchAgents/com.felixkratz.sketchybar.plist -->
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.felixkratz.sketchybar</string>
    <key>ProgramArguments</key>
    <array>
        <string>/Users/YOUR_USERNAME/.nix-profile/bin/sketchybar</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
</dict>
</plist>
```

Load it:
```bash
launchctl load ~/Library/LaunchAgents/com.felixkratz.sketchybar.plist
```


## Configuration Structure

```
.config/sketchybar/
├── sketchybarrc          # Main configuration file
├── colors.sh             # Color definitions
├── icons.sh              # Icon definitions
├── items/                # Bar item definitions
│   ├── apple.sh          # Apple menu
│   ├── spaces.sh         # Workspace display
│   ├── front_app.sh      # Active app display
│   ├── battery.sh
│   ├── calendar.sh
│   ├── cpu.sh
│   ├── gpu.sh
│   ├── ram.sh
│   ├── network.sh
│   ├── volume.sh
│   └── sensor.sh
├── plugins/              # Update scripts
│   ├── aerospace.sh      # Workspace update logic
│   ├── aerospace_poll.sh # Polling script
│   ├── front_app.sh      # App name/icon update
│   ├── front_app_click.sh # App menu popup
│   ├── icon_map.sh       # App icon mapping
│   ├── app_icon.sh       # Icon extraction
│   └── ...
└── README.md             # This file
```

## Customization

### Colors

Edit `colors.sh` to change the color scheme:

```bash
export BAR_COLOR=0xff1e1e2e
export BACKGROUND_1=0xff24273a
export RED=0xffed8796
export WHITE=0xffcad3f5
# ... more colors
```

### Workspace Names

Aerospace workspaces are defined in `~/.aerospace.toml`:

```toml
[workspace-to-monitor-force-assignment]
A = 1
B = 1
C = 1
D = 1
```

### App Icons

App icons are automatically detected via `plugins/app_icon.sh`. To add custom mappings, edit `plugins/icon_map.sh`:

```bash
"Your App Name")
  icon_result=":custom_icon:"
  ;;
```

## Troubleshooting

### Sketchybar not showing

```bash
# Check if running
pgrep -l sketchybar

# Restart
killall sketchybar && sketchybar &
```

### Workspaces not updating

```bash
# Check Aerospace is running
pgrep -l Aerospace

# Reload Sketchybar
sketchybar --reload
```

### Force Quit not working

1. Go to **System Settings** → **Privacy & Security** → **Accessibility**
2. Add `/usr/bin/osascript` and enable it
3. If using Nix, add the Nix store path:
   ```bash
   which osascript  # Copy this path
   # Add it to Accessibility permissions
   ```

### Front App not showing

```bash
# Manually trigger update
sketchybar --trigger front_app_switched

# Check script
export NAME=front_app
export CONFIG_DIR="$HOME/.config/sketchybar"
bash "$CONFIG_DIR/plugins/front_app.sh"
```

### Icons showing as "?"

This means the font is missing. Install sketchybar-app-font:

```bash
curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v2.0.5/sketchybar-app-font.ttf -o ~/Library/Fonts/sketchybar-app-font.ttf
```

## Performance

- **CPU Usage**: ~0.5-1% idle
- **Memory**: ~50-80MB
- **Update Frequency**: 
  - Workspaces: Event-driven + 1s polling
  - System stats: 2-5s intervals
  - Front app: Event-driven

## Credits

- **Inspiration**: [Felix Kratz's dotfiles](https://github.com/FelixKratz/dotfiles)
- **Sketchybar**: [FelixKratz/SketchyBar](https://github.com/FelixKratz/SketchyBar)
- **Aerospace**: [nikitabobko/AeroSpace](https://github.com/nikitabobko/AeroSpace)
- **App Font**: [kvndrsslr/sketchybar-app-font](https://github.com/kvndrsslr/sketchybar-app-font)

## License

MIT License - Feel free to use and modify!
