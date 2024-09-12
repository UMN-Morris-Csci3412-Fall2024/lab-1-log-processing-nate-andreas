#!/bin/bash

# Change to the specified directory
cd "$1"

# Initialize the output file
output_file="failed_login_data.txt"
> "$output_file"

# Process each log file in the directory
for log_file in *; do
  if [ -f "$log_file" ]; then
    # Extract and format failed login attempts
    grep "Failed password" "$log_file" | awk '{print $1, $2, substr($3, 1, 2), $9, $11}' >> "$output_file"
  fi
done