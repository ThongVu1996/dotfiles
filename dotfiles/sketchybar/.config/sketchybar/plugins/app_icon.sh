#!/bin/bash

APP_NAME="$1"
CACHE_DIR="$HOME/.cache/sketchybar/app_icons"
mkdir -p "$CACHE_DIR"

# Sanitize App Name for filename
SAFE_NAME=$(echo "$APP_NAME" | sed 's/[^a-zA-Z0-9]/_/g')
ICON_FILE="$CACHE_DIR/${SAFE_NAME}.png"

if [ ! -f "$ICON_FILE" ]; then
    # 1. Try finding by Bundle ID first (if passed)? No, we have Name.
    # Try mdfind
    APP_PATH=$(mdfind "kMDItemKind == 'Application' && kMDItemFSName == '${APP_NAME}.app'" | head -n 1)
    
    if [ -z "$APP_PATH" ]; then
        # Check standard paths
        if [ -d "/Applications/$APP_NAME.app" ]; then APP_PATH="/Applications/$APP_NAME.app"; fi
        if [ -d "/System/Applications/$APP_NAME.app" ]; then APP_PATH="/System/Applications/$APP_NAME.app"; fi
        if [ -d "/System/Library/CoreServices/$APP_NAME.app" ]; then APP_PATH="/System/Library/CoreServices/$APP_NAME.app"; fi
    fi

    # Handle Special Rewrite (e.g. Antigravity -> Terminal)
    if [ -z "$APP_PATH" ]; then
        if [[ "$APP_NAME" == "Antigravity" ]]; then
             # Default to Terminal or something known?
             # Antigravity is likely just a name. Let's use Terminal.app
             APP_PATH="/System/Applications/Utilities/Terminal.app"
        fi
        if [[ "$APP_NAME" == "Code" ]]; then
             APP_PATH="/Applications/Visual Studio Code.app" 
        fi
    fi

    if [ -n "$APP_PATH" ]; then
        # Read Info.plist for Icon Name
        ICON_NAME=$(defaults read "$APP_PATH/Contents/Info.plist" CFBundleIconFile 2>/dev/null)
        if [ -z "$ICON_NAME" ]; then ICON_NAME="AppIcon"; fi # Default
        
        # Add .icns extension if missing
        if [[ "$ICON_NAME" != *.icns ]]; then ICON_NAME="$ICON_NAME.icns"; fi
        
        ICON_SRC="$APP_PATH/Contents/Resources/$ICON_NAME"
        
        if [ ! -f "$ICON_SRC" ]; then
            # Try finding any .icns in Resources
            ICON_SRC=$(find "$APP_PATH/Contents/Resources" -name "*.icns" -maxdepth 1 | head -n 1)
        fi

        if [ -f "$ICON_SRC" ]; then
             # Convert using sips
             # Resize to 32x32 or 48x48 (Retina)
             sips -s format png --resampleHeightWidth 64 64 "$ICON_SRC" --out "$ICON_FILE" > /dev/null 2>&1
        fi
    fi
fi

if [ -f "$ICON_FILE" ]; then
    echo "$ICON_FILE"
else
    # Fallback to a default icon? Or empty.
    echo ""
fi
