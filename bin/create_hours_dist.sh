#!/bin/bash

# Check if directory argument is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

target_dir="$1"

# Check if target directory exists
if [ ! -d "$target_dir" ]; then
    echo "Error: Directory $target_dir does not exist"
    exit 1
fi

# Create temporary file for the data
temp_file=$(mktemp)

# Process all failed_login_data.txt files in subdirectories
find "$target_dir" -name failed_login_data.txt -exec cat {} \; | \
    # Extract just the hour (field 3) from the input
    awk '{printf "%02d\n", $3}' | \
    sort | \
    uniq -c | \
    sort -k2 | \
    # Format the output exactly as expected (with a leading space)
    awk '{printf " data.addRow(['\''%s'\'', %d]);\n", $2, $1}' > "$temp_file"

# Use wrap_contents.sh with the correct component name
./bin/wrap_contents.sh \
    "html_components/hours_dist" \
    "$temp_file" \
    "$target_dir/hours_dist.html"

# Clean up temporary file
rm "$temp_file"