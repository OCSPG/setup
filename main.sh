#!/bin/bash

script_dir="scripts"
scripts=()

# Read available scripts in the "scripts" folder
i=1
echo "The following scripts are available:"
for script_file in "$script_dir"/*.sh; do
  script_name=$(basename "$script_file")
  script_name=${script_name#*_}  # Remove the numbering prefix
  echo "$i. $script_name"
  scripts+=("$script_file")
  ((i++))
done

# Read user selection
read -rp "Which scripts would you like to run? Select by typing numbers separated by spaces (or 'a' for all): " selection

if [ "$selection" = "a" ]; then
  selected_scripts=("${scripts[@]}")
else
  IFS=" " read -ra selected_scripts <<< "$selection"
  for script_index in "${selected_scripts[@]}"; do
    index=$((script_index-1))
    if [ "$index" -ge 0 ] && [ "$index" -lt "${#scripts[@]}" ]; then
      selected_script="${scripts[$index]}"
      selected_scripts[$((index))]="$selected_script"
    else
      echo "Invalid selection: $script_index"
      exit 1
    fi
  done
fi

# Execute selected scripts
for script_file in "${selected_scripts[@]}"; do
  echo "Running $script_file..."
  bash "$script_file"
done
