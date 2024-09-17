#!/bin/bash

# Ensure a directory argument is provided
if [[ -z "$1" ]]; then
  echo "Usage: $0 <client_log_directory>"
  exit 1
fi

# Assign the provided directory to a variable
log_directory="$1"

# Check if the provided directory exists
if [[ ! -d "$log_directory" ]]; then
  echo "Error: Directory '$log_directory' does not exist."
  exit 1
fi

# Define the output file for failed login data
output_file="$log_directory/failed_login_data.txt"

# Initialize/clear the output file
> "$output_file"

# Process each log file in the client directory
for log_file in "$log_directory"/**/log/*; do
  if [[ -f "$log_file" ]]; then
    # Extract failed login attempts from the log file and write to the output file
    grep "Failed password" "$log_file" | \
    awk '{print $1, $2, $3, $9, $11}' >> "$output_file"
  fi
done

echo "Failed login data has been written to $output_file"
