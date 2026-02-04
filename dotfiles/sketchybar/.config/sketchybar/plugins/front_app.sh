#!/bin/bash

# $INFO contains the app name provided by the front_app_switched event
APP_NAME="$INFO"

# Fallback if event didn't provide name
if [ -z "$APP_NAME" ]; then
  APP_NAME=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true')
fi

# Get icon mapping
ICON=$("$CONFIG_DIR/plugins/icon_map.sh" "$APP_NAME")

# Update Item
sketchybar --set $NAME \
           label="$APP_NAME" \
           icon="$ICON" \
           icon.drawing=on \
           label.drawing=on \
           background.color=0x44ffffff \
           background.drawing=on
