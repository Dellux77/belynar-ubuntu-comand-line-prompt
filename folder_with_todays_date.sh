#!/bin/bash

# Script to create a folder with today's date

echo "Creating folder with today's date..."

# Get today's date in YYYY-MM-DD format
today=$(date +"%Y-%m-%d")

# Alternative date formats (uncomment the one you prefer):
# today=$(date +"%Y%m%d")           # Format: 20250806
# today=$(date +"%d-%m-%Y")         # Format: 06-08-2025
# today=$(date +"%B_%d_%Y")         # Format: August_06_2025

# Create the folder
if mkdir "$today" 2>/dev/null; then
    echo "✓ Folder '$today' created successfully!"
    echo "  Location: $(pwd)/$today"
else
    echo "✗ Error: Folder '$today' already exists or cannot be created."
    exit 1
fi

# Optional: Change to the new directory
# cd "$today" && echo "  Changed to directory: $(pwd)"

# Optional: Create a README file in the new folder
# echo "Folder created on $(date)" > "$today/README.txt"
# echo "  Added README.txt to the folder"
