
#!/usr/bin/env bash

# Counter for lolcat color cycling
counter=0

# Loop indefinitely
while :; do
  counter=$((counter + 2)) # Increment the counter
  tput cup 0 0             # Move cursor to the top-left

  # Use figlet with lolcat to display dynamic text
  figlet -f /home/linuxbrew/.linuxbrew/Cellar/figlet/2.2.5/share/figlet/ansi_shadow.flf -ct "$1" | lolcat -F 0.5 -S "$counter" -f
  # lolcat $1 -S $counter -f

  # Adjust sleep duration to control update speed
  sleep 0.01
done
