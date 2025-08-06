#!/bin/bash

# Script to list all files in a folder and count them

echo "File Listing and Counter"
echo "======================="

# Determine which folder to examine
if [ $# -eq 1 ]; then
    # Use folder provided as argument
    folder="$1"
else
    # Use current directory if no argument provided
    folder="."
fi

# Check if the folder exists
if [ ! -d "$folder" ]; then
    echo "Error: '$folder' is not a valid directory"
    exit 1
fi

echo "Examining folder: $(realpath "$folder")"
echo ""

# List all files (excluding directories)
echo "Files in the folder:"
echo "-------------------"

file_count=0
for item in "$folder"/*; do
    # Check if glob didn't match anything
    if [ ! -e "$item" ]; then
        echo "No files found in this folder"
        break
    fi
    
    # Only list files (not directories)
    if [ -f "$item" ]; then
        echo "$(basename "$item")"
        ((file_count++))
    fi
done

echo ""
echo "Total number of files: $file_count"

# Optional: Show additional information
echo ""
echo "Additional Information:"
echo "----------------------"

# Count directories separately
dir_count=$(find "$folder" -maxdepth 1 -type d ! -path "$folder" | wc -l)
echo "Directories: $dir_count"

# Count hidden files
hidden_count=$(find "$folder" -maxdepth 1 -name ".*" -type f 2>/dev/null | wc -l)
echo "Hidden files: $hidden_count"

# Total items (files + directories, excluding . and ..)
total_items=$(find "$folder" -maxdepth 1 ! -path "$folder" | wc -l)
echo "Total items (files + directories): $total_items"
