#!/bin/bash

# Load colors
source "$CONFIG_DIR/colors.sh"

# 1. Main Apple Item
sketchybar --add item apple left \
           --set apple \
           display=all \
           ignore_association=on \
           drawing=on \
           icon="" \
           icon.font="SF Pro:Black:20.0" \
           icon.color=$WHITE \
           icon.padding_left=12 \
           icon.padding_right=12 \
           label.drawing=off \
           click_script="sketchybar --set apple popup.drawing=toggle"

# 2. Popup Items Function
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

  # Hover effects
  local hover_on="sketchybar --set apple.$name background.color=$BACKGROUND_2"
  local hover_off="sketchybar --set apple.$name background.color=0x00000000"

  sketchybar --add item "apple.$name" popup.apple \
             --set "apple.$name" \
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
             click_script="$script; sketchybar --set apple popup.drawing=off"
}

add_separator() {
  local id="$1"
  sketchybar --add item "apple.sep$id" popup.apple \
             --set "apple.sep$id" \
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
sketchybar --remove '/apple\..*/'

# Add items
add_menu_item "about" "About This Mac" "󰀵" "open 'x-apple.systempreferences:com.apple.SystemProfiler.AboutExtension'" ""

add_separator 1

add_menu_item "settings" "System Settings..." "󰒓" "open -a 'System Settings'" ""
add_menu_item "appstore" "App Store..." "󰀵" "open -a 'App Store'" ""
add_menu_item "recent" "Recent Items" "󰄉" "open 'x-apple.systempreferences:com.apple.preference.general'" ""

add_separator 2

# Force Quit: Dùng phím tắt hệ thống (Key code 53 = Escape)
# FORCE_QUIT_SCRIPT="osascript -e 'tell application \"System Events\" to key code 53 using {command down, option down}'"
FORCE_QUIT_SCRIPT="open -a 'Activity Monitor'"
add_menu_item "force_quit" "Force Quit..." "󰆤" "$FORCE_QUIT_SCRIPT" "⌥⌘⎋"

add_separator 3

add_menu_item "sleep" "Sleep" "󰒲" "pmset sleepnow" ""
add_menu_item "restart" "Restart..." "󰜉" "osascript -e 'tell app \"System Events\" to restart'" ""
add_menu_item "shutdown" "Shut Down..." "⏻" "osascript -e 'tell app \"System Events\" to shut down'" ""

add_separator 4

add_menu_item "lock" "Lock Screen" "󰌾" "pmset displaysleepnow" "⌃⌘Q"
add_menu_item "logout" "Log Out $USER" "󰍃" "osascript -e 'tell app \"System Events\" to log out'" "⇧⌘Q"

# Global popup styling
sketchybar --set apple popup.background.color=$POPUP_BACKGROUND_COLOR \
                       popup.background.corner_radius=10 \
                       popup.background.border_width=1 \
                       popup.background.border_color=$POPUP_BORDER_COLOR \
                       popup.blur_radius=25
