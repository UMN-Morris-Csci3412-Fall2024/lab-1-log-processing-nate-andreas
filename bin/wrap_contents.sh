#!/bin/bash

# Check for correct number of arguments
if [ $# -ne 3 ]; then
    echo "Usage: $0 <html_template> <content_file> <output_file>"
    exit 1
fi

# Get the arguments
html_template="$1"
content_file="$2"
output_file="$3"

# Create the final HTML file by concatenating the header, content, and footer
cat "${html_template}_header.html" "$content_file" "${html_template}_footer.html" > "$output_file"