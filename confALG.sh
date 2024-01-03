#!/bin/bash


while :
do
  echo "Input directories to scan for log files: "
  read directorie
  if [ -d "$directorie" ]; then
    break 
  else
    echo "Error: No directories specified or the specified directories are empty."
  fi
done

while :
do
  echo "Input days you want to archive from: "
  read age

  if [ "$age" -gt 0 ] 2>/dev/null && [ "$age" -eq "$age" ] 2>/dev/null; then
    break
  else
    echo "Invalid input! Please enter a positive integer."
  fi
done


while :
do
  echo "Set auto run on midnight using cron: "
  read use_autorun

  if [ -n "$use_autorun" ] && ( [ "$use_autorun" = "yes" ] || [ "$use_autorun" = "y" ] || [ "$use_autorun" = "no" ] || [ "$use_autorun" = "n" ] ); then
    break
  else
    echo "Invalid Input!"
  fi
done


# Specify the file path for the configuration file
config_file="./conf/config.conf"

# Check if the conf file exists
if [ ! -f "$config_file" ]; then
    touch "$config_file"
fi

# overwrite the configuration file
cat > "$config_file" <<EOL
DIRS="$directorie"
LOG_AGE="$age"
EOL


echo "Configuration file generated at: $config_file"


# This will set script autorun on midnight
script_path="$(cd "$(dirname "$0")" && pwd)/logALG.sh"


if [ -n "$use_autorun" ] && { [ "$use_autorun" = "yes" ] || [ "$use_autorun" = "y" ]; }; then
  echo "In 20 seconds, a window will open. Add the following line and save to schedule the script at midnight:"
  echo "0 0 * * * $script_path"
  
  sleep 20  # Wait for 1 minute before opening the crontab editor
  crontab -e

  if [ $? -eq 0 ]; then
    echo "Cron job added successfully."
  else
    echo "Error: Failed to add cron job. Please add the cron job manually."
  fi
else
  echo "Autorun not used!"
fi




echo "Starting log job"
sudo sh ./logALG.sh

