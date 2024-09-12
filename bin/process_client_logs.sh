#!/bin/bash

# Check if a directory is provided as an argument
if [ -z "$1" ] || [ ! -d "$1" ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

# Change to the specified directory
cd "$1"

# Process all log files in the directory
cat *.log | awk '
# Match lines with failed login attempts for invalid users
/Failed password for invalid user/ {
    split($0, fields, " ");
    # Extract date, hour, computer name, username, and IP address
    print fields[1] " " fields[2] " " substr(fields[3], 1, 2) " " fields[8] " " fields[10];
}
# Match lines with failed login attempts for valid users
/Failed password for [a-zA-Z0-9_-]* from/ {
    split($0, fields, " ");
    # Extract date, hour, computer name, username, and IP address
    print fields[1] " " fields[2] " " substr(fields[3], 1, 2) " " fields[7] " " fields[9];
}
' | sed 's/:..:.. / /' > failed_login_data.txt