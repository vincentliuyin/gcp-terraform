#!/bin/bash

output_file="combined_contents.txt"
> "$output_file" # Clear the output file if it exists

# Function to process each file
process_file() {
    local file_path="$1"
    echo "File: $file_path" >> "$output_file"

    if [ ! -s "$file_path" ]; then
        # The file is empty
        echo "empty" >> "$output_file"
    else
        # Append the file's content
        cat "$file_path" >> "$output_file"
    fi

    # Add a newline for separation
    echo "" >> "$output_file"
}

# Export the function so it's available to subshells
export -f process_file
export output_file
rm -rf $output_file

# Find and process all files, excluding hidden files and Terraform state files
find . -type f -not -path '*/\.*' -not -name '*.tfstate' -not -name '*.sh' -not -name '*.txt'  -not -name '*.tfstate.backup' -exec bash -c 'process_file "$0"' {} \;

echo "All contents have been combined into $output_file."
