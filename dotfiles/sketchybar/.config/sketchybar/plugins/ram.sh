#!/bin/bash

# Get memory pages
PAGESIZE=$(sysctl -n hw.pagesize)
MEM_TOTAL=$(sysctl -n hw.memsize)

VM_STAT=$(vm_stat)
PAGES_FREE=$(echo "$VM_STAT" | grep "Pages free" | awk '{print $3}' | tr -d '.')
PAGES_ACTIVE=$(echo "$VM_STAT" | grep "Pages active" | awk '{print $3}' | tr -d '.')
PAGES_WIRED=$(echo "$VM_STAT" | grep "Pages wired down" | awk '{print $4}' | tr -d '.')
PAGES_COMPRESSED=$(echo "$VM_STAT" | grep "Pages occupied by compressor" | awk '{print $5}' | tr -d '.')

PAGES_ACTIVE=${PAGES_ACTIVE:-0}
PAGES_WIRED=${PAGES_WIRED:-0}
PAGES_COMPRESSED=${PAGES_COMPRESSED:-0}

USED_PAGES=$((PAGES_ACTIVE + PAGES_WIRED + PAGES_COMPRESSED))
USED_BYTES=$((USED_PAGES * PAGESIZE))

# Format %.0f for integer without leading zero
PERCENT=$(awk -v used="$USED_BYTES" -v total="$MEM_TOTAL" 'BEGIN { printf "%.0f", (used/total)*100 }')

# Debug
echo "$(date) RAM: Used=$USED_BYTES Total=$MEM_TOTAL Percent=$PERCENT" >> /tmp/sketchybar_ram.log

sketchybar --set $NAME label="$PERCENT%"
