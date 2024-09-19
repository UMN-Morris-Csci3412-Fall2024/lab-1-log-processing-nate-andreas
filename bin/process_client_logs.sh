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

# Temporary file to store intermediate results
temp_file=$(mktemp)

# Find all log files recursively in the client directory
find "$log_directory" -type f -name 'log*' | while read -r log_file; do
  # Extract failed login attempts from the log file and write to the temp file
  grep "Failed password" "$log_file" | awk '{printf "%s %s %s %s %s\n", $1, $2, $3, $9, $11}' >> "$temp_file"
done

# Sort and remove duplicate lines, then write to the output file
sort -u "$temp_file" > "$output_file"

# Remove the temporary file
rm "$temp_file"

echo "Failed login data has been written to $output_file"