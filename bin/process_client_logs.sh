#!/bin/bash

# Check if directory argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <directory>"
  exit 1
fi

# Change to the specified directory
cd "$1" || { echo "Failed to change directory to $1"; exit 1; }

# Initialize the output file
output_file="failed_login_data.txt"
> "$output_file"

# Process each log file in the directory
for log_file in *; do
  if [ "$log_file" != "$output_file" ] && [ -f "$log_file" ]; then
    echo "Processing $log_file"
    # Extract and format failed login attempts
    grep "Failed password" "$log_file" | awk '{print $1, $2, substr($3, 1, 2), $9, $11}' >> "$output_file"
  else
    echo "$log_file is not a regular file, skipping"
  fi
done

echo "Processing complete. Output written to $output_file"