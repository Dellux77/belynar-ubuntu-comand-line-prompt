#!/bin/bash

# File Organizer Script
# Sorts files in the current directory by their extensions

# Create a directory for each file extension and move files there

echo "Starting file organization by extension..."

# Process each file in the current directory
for file in *; do
    # Skip directories and this script itself
    if [[ -d "$file" ]] || [[ "$file" == "organize.sh" ]]; then
        continue
    fi
    
    # Get the file extension (everything after the last dot)
    extension="${file##*.}"
    
    # Handle files without extension
    if [[ "$extension" == "$file" ]]; then
        extension="no_extension"
    fi
    
    # Create directory if it doesn't exist
    if [[ ! -d "$extension" ]]; then
        mkdir -p "$extension"
        echo "Created directory: $extension"
    fi
    
    # Move the file to the appropriate directory
    mv "$file" "$extension/"
    echo "Moved $file to $extension/"
done

echo "File organization complete!"
