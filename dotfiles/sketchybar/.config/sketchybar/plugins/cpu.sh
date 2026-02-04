#!/bin/bash

CORE_COUNT=$(sysctl -n machdep.cpu.thread_count)
CPU_INFO=$(ps -A -o %cpu | awk '{s+=$1} END {print s}')

CPU_PERCENT=$(echo "$CPU_INFO / $CORE_COUNT" | bc)
# Use %.0f to round to integer without leading zero padding
CPU_LABEL=$(printf "%.0f" $CPU_PERCENT)

sketchybar --set $NAME label="$CPU_LABEL%"


# #!/bin/bash

# # Lấy thông số CPU
# CORE_PERCENT=$(top -l 1 | grep -E "^CPU" | grep -oE '[^ ]+$')
# CPU_PERCENT=${CORE_PERCENT%.*}

# # CHỈ update LABEL, không đụng vào icon hay width
# sketchybar --set $NAME label="$CPU_PERCENT%"