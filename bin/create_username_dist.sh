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
    # Extract just the username (field 4) from the input
    awk '{print $4}' | \
    sort | \
    uniq -c | \
    sort -k2 | \
    # Format the output exactly as expected (with a leading space)
    awk '{printf " data.addRow(['\''%s'\'', %d]);\n", $2, $1}' > "$temp_file"

# Use wrap_contents.sh with the correct component name
./bin/wrap_contents.sh \
    "html_components/username_dist" \
    "$temp_file" \
    "$target_dir/username_dist.html"

# Clean up temporary file
rm "$temp_file"