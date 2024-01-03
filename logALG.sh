#!/bin/bash

LOG_FILE="./log/logs.logs"
MAIN_SCRIPT="./ALG.sh"

# Check if the log file exists
if [ ! -f "$LOG_FILE" ]; then
    touch "$LOG_FILE"
fi

# Run the main script, append both stdout and stderr to the log file, and display on console
{
    echo "Script started at $(date)"
    sudo sh "$MAIN_SCRIPT"
    echo "Script finished at $(date)"
} 2>&1 | tee -a "$LOG_FILE"
