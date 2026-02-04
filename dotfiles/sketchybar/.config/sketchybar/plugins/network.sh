#!/bin/bash

# Update frequency
UPDATE_FREQ=2
IFACE="en0"

STATS=$(netstat -ib | grep -e "$IFACE" -m 1 | awk '{print $7, $10}')
BYTES_IN=$(echo $STATS | awk '{print $1}')
BYTES_OUT=$(echo $STATS | awk '{print $2}')

TMP_FILE="/tmp/sketchybar_network.dat"

if [ -f "$TMP_FILE" ]; then
  PREV_STATS=$(cat "$TMP_FILE")
  PREV_IN=$(echo $PREV_STATS | awk '{print $1}')
  PREV_OUT=$(echo $PREV_STATS | awk '{print $2}')

  DELTA_IN=$((BYTES_IN - PREV_IN))
  DELTA_OUT=$((BYTES_OUT - PREV_OUT))

  SPEED_IN=$((DELTA_IN / UPDATE_FREQ))
  SPEED_OUT=$((DELTA_OUT / UPDATE_FREQ))

  format_speed() {
    local speed=$1
    if [ $speed -lt 1024 ]; then
      echo "${speed}B/s"
    elif [ $speed -lt 1048576 ]; then
      echo "$((speed / 1024))KB/s"
    else
      awk -v s=$speed 'BEGIN { printf "%.1fMB/s", s / 1048576 }'
    fi
  }

  DOWN_FORMAT=$(format_speed $SPEED_IN)
  UP_FORMAT=$(format_speed $SPEED_OUT)

  # Single Item Strategy:
  # Icon = Upload (Top)
  # Label = Download (Bottom)
  sketchybar --set network.traffic \
             icon="↑ $UP_FORMAT" \
             label="↓ $DOWN_FORMAT"
fi

echo "$BYTES_IN $BYTES_OUT" > "$TMP_FILE"
