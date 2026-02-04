#!/bin/bash

LOG_FILE="/tmp/sketchybar_wifi_debug.log"
echo "$(date): Script triggered" >> "$LOG_FILE"

# Get current state
POPUP_STATE=$(sketchybar --query network.wifi | jq -r '.popup.drawing')
echo "$(date): Current State: $POPUP_STATE" >> "$LOG_FILE"

if [ "$POPUP_STATE" = "on" ]; then
  sketchybar --set network.wifi popup.drawing=off
else
  echo "$(date): Fetching Wifi Info..." >> "$LOG_FILE"
  # Fetch Info
  # Note: ipconfig can be slow or return empty if interface is wrong. 
  # Check if en0 is correct on your machine.
  
  ifconfig -u | grep -q "en0" 
  if [ $? -eq 0 ]; then
      SSID=$(ipconfig getsummary en0 | awk -F ' SSID : '  '/ SSID : / {print $2}')
      IP=$(ipconfig getifaddr en0)
  else
      # Try en1 if en0 is not active
      SSID=$(ipconfig getsummary en1 | awk -F ' SSID : '  '/ SSID : / {print $2}')
      IP=$(ipconfig getifaddr en1)
  fi

  echo "$(date): SSID: $SSID, IP: $IP" >> "$LOG_FILE"
  
  if [ -z "$SSID" ]; then
    SSID="Not Connected"
    ICON=􀙈
    COLOR=0xffed8796 # Red
  else
    ICON=􀙇
    COLOR=0xffa6da95 # Green
  fi

  # Update and Open Popup
  sketchybar --set network.wifi.ssid label="$SSID" icon="$ICON" icon.color=$COLOR \
             --set network.wifi.ip   label="$IP" \
             --set network.wifi popup.drawing=on
fi
