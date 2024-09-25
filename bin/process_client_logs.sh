# Store the absolute path of the current directory
current_dir=$(pwd)

# Check if directory exists
if [ ! -d "$1" ]; then
    echo "Directory $1 does not exist."
    exit 1
fi

# Define output file path
output_file_path="$current_dir/data/discovery/failed_login_data.txt"

# Create the directory if it doesn't exist
mkdir -p "$(dirname "$output_file_path")"

# Remove old failed_login_data.txt if it exists
rm -f "$output_file_path"

# Move to the specified directory
cd "$1" || exit

# Process log files
for file in *
do
    if [ -f "$file" ]; then

    fi
done