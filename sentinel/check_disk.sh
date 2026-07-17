#!/usr/bin/env bash
# check_disk.sh - warn if disk usage is above a threshold

# Threshold in percent: use the argument if given, otherwise 90.
UMBRAL="${1:-90}"

# Extract the disk usage percentage of "/" as a plain number.
USO=$(df -h / | tail -1 | awk '{print $5}' | tr -d '%')

# Compare the number against the threshold.
if [ "$USO" -ge "$UMBRAL" ]; then
    echo "ALERT - disk at $USO% (threshold $UMBRAL%)"
else
    echo "OK     - disk at $USO%"
fi
