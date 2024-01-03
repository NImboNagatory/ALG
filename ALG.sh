#!/bin/bash

config_file="./conf/config.conf"

# Check if the configuration file exists
if [ -f "$config_file" ]; then
    # Source the configuration file to load the variables
    source "$config_file"
else
    echo "Error: Configuration file not found at $config_file"
    exit 1
fi

archive_dir="./archive"

# Check if the archive dir exists
if [ ! -d "$archive_dir" ]; then
    if mkdir -p "$archive_dir"; then
        echo "Directory '$archive_dir' created successfully."
    else
        echo "Error: Unable to create directory '$archive_dir'."
        exit 1
    fi
fi



for i in $(find "$DIRS" -name "*.log" -type f); do
    min_temp=$((LOG_AGE * 1440))

    # Check if the file's last modification time is greater than min_temp
    if [ "$(find "$i" -mmin +$min_temp)" ]; then
        mv "$i" "$archive_dir"
        echo "Moved '$i' to '$archive_dir'."
    fi
done




