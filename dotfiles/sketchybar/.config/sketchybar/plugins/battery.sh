#!/bin/bash

# Source colors to use variables like $GREEN, $RED, $WHITE
source "$CONFIG_DIR/colors.sh"

BATTERY_INFO="$(pmset -g batt)"
PERCENTAGE=$(echo "$BATTERY_INFO" | grep -oE '[0-9]+%' | cut -d% -f1)
CHARGING=$(echo "$BATTERY_INFO" | grep 'AC Power')

if [ -z "$PERCENTAGE" ]; then
  exit 0
fi

# Default color for the Icon (which will be in the LABEL slot)
COLOR=$WHITE 
DRAWING=on

if [ -n "$CHARGING" ]; then
  # Charging Icon
  ICON=􀢋
  COLOR=$GREEN
else
  # Discharging Icons
  case ${PERCENTAGE} in
    9[0-9]|100) ICON=􀛨 ;;
    [6-8][0-9]) ICON=􀺸 ;;
    [3-5][0-9]) ICON=􀺶 ;;
    [1-2][0-9]) ICON=􀛩 ;;
    *) ICON=􀛪; COLOR=$RED ;;
  esac
fi

# Swap: 
# icon="..." gets the PERCENTAGE
# label="..." gets the ICON
# We color the label (Icon) and keep the icon (Text) white.

sketchybar --set $NAME drawing=$DRAWING \
                       icon="${PERCENTAGE}%" \
                       icon.color=$WHITE \
                       label="$ICON" \
                       label.color=$COLOR
