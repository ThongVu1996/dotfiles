#!/bin/bash

source "$CONFIG_DIR/colors.sh"

# Get current front app name
APP_NAME=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true')

# Function to add menu items (Adapted from apple.sh)
add_menu_item() {
  local name="$1"
  local label_text="$2"
  local icon_left="$3"
  local script="$4"
  local shortcut="$5"
  
  local full_text=""
  if [ -z "$icon_left" ]; then
    full_text="$label_text"
  else
    full_text="$icon_left   $label_text"
  fi

  local hover_on="sketchybar --set front_app.$name background.color=$BACKGROUND_2"
  local hover_off="sketchybar --set front_app.$name background.color=0x00000000"

  sketchybar --add item "front_app.$name" popup.front_app \
             --set "front_app.$name" \
             icon="$full_text" \
             icon.font="$FONT:Semibold:14.0" \
             icon.color=$WHITE \
             icon.align=left \
             icon.padding_left=10 \
             label="$shortcut" \
             label.font="$FONT:Regular:12.0" \
             label.color=$GREY \
             label.align=right \
             label.padding_right=15 \
             width=240 \
             padding_left=0 \
             padding_right=0 \
             padding_top=0 \
             padding_bottom=0 \
             background.height=28 \
             background.corner_radius=6 \
             background.drawing=on \
             background.color=0x00000000 \
             mouse.entered="$hover_on" \
             mouse.exited="$hover_off" \
             click_script="$script; sketchybar --set front_app popup.drawing=off"
}

add_separator() {
  local id="$1"
  sketchybar --add item "front_app.sep$id" popup.front_app \
             --set "front_app.sep$id" \
             icon.drawing=off \
             label.drawing=off \
             background.height=1 \
             background.color=0x33ffffff \
             background.drawing=on \
             background.padding_left=10 \
             background.padding_right=10 \
             padding_top=4 \
             padding_bottom=4 \
             width=240
}

# Clear old items
sketchybar --remove '/front_app\..*/'

# AppleScript Commands
CMD_SETTINGS="osascript -e 'tell application \"System Events\" to keystroke \",\" using command down'"
CMD_HIDE="osascript -e 'tell application \"System Events\" to keystroke \"h\" using command down'"
CMD_HIDE_OTHERS="osascript -e 'tell application \"System Events\" to keystroke \"h\" using {command down, option down}'"
CMD_QUIT="osascript -e 'tell application \"System Events\" to keystroke \"q\" using command down'"

# Build Menu
add_menu_item "about" "About $APP_NAME" "󰕒" "open -a '$APP_NAME'" ""
add_separator 1

add_menu_item "settings" "Settings..." "󰒓" "$CMD_SETTINGS" "⌘,"
add_separator 2

add_menu_item "hide" "Hide $APP_NAME" "󰘷" "$CMD_HIDE" "⌘H"
add_menu_item "hide_others" "Hide Others" "󰘷" "$CMD_HIDE_OTHERS" "⌥⌘H"
add_separator 3

add_menu_item "quit" "Quit $APP_NAME" "󰗼" "$CMD_QUIT" "⌘Q"

# Toggle Popup
sketchybar --set front_app popup.drawing=toggle \
           popup.background.color=$POPUP_BACKGROUND_COLOR \
           popup.background.corner_radius=10 \
           popup.background.border_width=1 \
           popup.background.border_color=$POPUP_BORDER_COLOR \
           popup.blur_radius=25
