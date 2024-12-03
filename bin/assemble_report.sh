#!/bin/bash
[ $# -ne 1 ] && echo "Usage: $0 <directory>" && exit 1
target_dir="$1"
[ ! -d "$target_dir" ] && exit 1

temp_file=$(mktemp)
{
    # Extract JavaScript content from files
    for file in "username_dist.html" "hours_dist.html" "country_dist.html"; do
        sed -n '/START OF.*HEADER/,/END OF.*FOOTER/p' "$target_dir/$file"
    done
} > "$temp_file"

# Use wrap_contents.sh for the HTML structure
./bin/wrap_contents.sh "html_components/overall" "$temp_file" "$target_dir/failed_login_summary.html"
rm "$temp_file"