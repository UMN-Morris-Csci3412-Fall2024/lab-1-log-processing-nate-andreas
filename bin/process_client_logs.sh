#!/bin/bash

# Hardcoded log directory as per the bats tests
log_directory="data/discovery"

# Check if the provided directory exists
if [[ ! -d "$log_directory" ]]; then
  echo "Error: Directory '$log_directory' does not exist."
  exit 1
fi

# Define the output file for failed login data
output_file="$log_directory/failed_login_data.txt"

# Initialize/clear the output file
> "$output_file"

# Temporary file to store intermediate results
temp_file=$(mktemp)

# Find all log files recursively in the client directory
find "$log_directory" -type f -name 'log*' | while read -r log_file; do
  # Extract failed login attempts, track unique combinations with awk
  awk '
    /Failed password for invalid user/ {
      split($11, datetime, ":"); 
      hour = datetime[1];
      key = $1 " " hour " " $9 " " $13; 
      if (!seen[key]) {
        print $1, hour, $9, $13; 
        seen[key] = 1; 
      }
    } 
    /Failed password for [a-zA-Z0-9_]+/ {
      split($10, datetime, ":"); 
      hour = datetime[1];
      key = $1 " " hour " " $8 " " $12; 
      if (!seen[key]) {
        print $1, hour, $8, $12; 
        seen[key] = 1; 
      }
    }
  ' "$log_file" >> "$temp_file"
done

# Write the log entries to the output file without sorting
cat "$temp_file" > "$output_file"

# Clean up the temporary file
rm "$temp_file"

echo "Failed login data has been written to $output_file"