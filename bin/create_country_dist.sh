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

# Create temporary files
temp_ip_file=$(mktemp)
temp_data_file=$(mktemp)
sorted_country_map=$(mktemp)

# Sort country map file first
sort "etc/country_IP_map.txt" > "$sorted_country_map"

# Process all failed_login_data.txt files
find "$target_dir" -name failed_login_data.txt -exec cat {} \; | \
    awk '{print $5}' | \
    sort | \
    uniq -c | \
    # Reverse columns to put IP first for join
    awk '{print $2 " " $1}' > "$temp_ip_file"

# Join with sorted country map and sum by country
join -1 1 -2 1 "$temp_ip_file" "$sorted_country_map" | \
    awk '{counts[$3] += $2} END {
        for (country in counts) 
            print country, counts[country]
    }' | \
    sort | \
    awk '{printf "data.addRow(['\''%s'\'', %d]);\n", $1, $2}' > "$temp_data_file"

# Wrap contents
./bin/wrap_contents.sh \
    "html_components/country_dist" \
    "$temp_data_file" \
    "$target_dir/country_dist.html"

# Clean up
rm "$temp_ip_file"
rm "$temp_data_file"
rm "$sorted_country_map"