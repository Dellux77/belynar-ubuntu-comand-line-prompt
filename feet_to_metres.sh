#!/bin/bash

# Optimized File Backup Script
# Performance improvements and reduced resource usage

set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Configuration
readonly BACKUP_DIR="${BACKUP_HOME:-$HOME/backups}"
readonly LOG_FILE="$BACKUP_DIR/backup.log"
readonly TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
readonly DAYS_TO_KEEP=${BACKUP_RETENTION:-30}

# Important files - use associative array for O(1) lookups
declare -A IMPORTANT_FILES=(
    ["bashrc"]="$HOME/.bashrc"
    ["bash_profile"]="$HOME/.bash_profile" 
    ["gitconfig"]="$HOME/.gitconfig"
    ["documents"]="$HOME/Documents"
    ["desktop_project"]="$HOME/Desktop/important_project"
)

# Counters
declare -i SUCCESS_COUNT=0
declare -i TOTAL_COUNT=${#IMPORTANT_FILES[@]}

# Logging function - single write operation
log() {
    printf '%s: %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$1" | tee -a "$LOG_FILE" >&2
}

# Create backup directory only once
init_backup_dir() {
    [[ -d "$BACKUP_DIR" ]] || {
        mkdir -p "$BACKUP_DIR" && log "Created backup directory: $BACKUP_DIR"
    }
}

# Optimized backup function
backup_item() {
    local -r source="$1"
    local -r name="$2"
    
    [[ -e "$source" ]] || {
        log "✗ Skipping: $source (not found)"
        return 1
    }
    
    local -r dest="$BACKUP_DIR/${name}_${TIMESTAMP}"
    
    if [[ -f "$source" ]]; then
        cp "$source" "$dest" && log "✓ File: $source"
    elif [[ -d "$source" ]]; then
        # Use rsync for better directory copying if available, fallback to cp
        if command -v rsync >/dev/null 2>&1; then
            rsync -a "$source/" "$dest/" && log "✓ Dir (rsync): $source"
        else
            cp -r "$source" "$dest" && log "✓ Dir: $source"
        fi
    fi
}

# Parallel cleanup using find's -delete for better performance
cleanup_old_backups() {
    log "Cleaning backups older than $DAYS_TO_KEEP days..."
    
    # Single find command with multiple actions
    find "$BACKUP_DIR" -maxdepth 1 \( -name "*_[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]_*" \) \
         -mtime +$DAYS_TO_KEEP \( -type f -delete -o -type d -exec rm -rf {} + \) 2>/dev/null || true
    
    log "Cleanup completed"
}

# Main backup process - optimized loop
run_backup() {
    echo "Starting backup: $(date)"
    echo "Target: $BACKUP_DIR"
    
    init_backup_dir
    
    # Check if any files configured
    (( TOTAL_COUNT > 0 )) || {
        echo "No files configured. Edit IMPORTANT_FILES array."
        exit 1
    }
    
    # Process backups
    for name in "${!IMPORTANT_FILES[@]}"; do
        backup_item "${IMPORTANT_FILES[$name]}" "$name" && ((SUCCESS_COUNT++)) || true
    done
    
    # Single summary output
    printf '\nSummary: %d/%d successful\n' "$SUCCESS_COUNT" "$TOTAL_COUNT"
    log "Backup session completed: $SUCCESS_COUNT/$TOTAL_COUNT"
    
    # Auto-cleanup if success rate > 80%
    (( SUCCESS_COUNT * 100 / TOTAL_COUNT > 80 )) && cleanup_old_backups
}

# Fast directory size check
show_size() {
    [[ -d "$BACKUP_DIR" ]] && du -sh "$BACKUP_DIR" 2>/dev/null || echo "Backup directory not found"
}

# Optimized directory listing
list_backups() {
    [[ -d "$BACKUP_DIR" ]] && ls -1t "$BACKUP_DIR" 2>/dev/null || echo "Backup directory not found"
}

# Usage information
show_help() {
    cat << 'EOF'
Optimized Backup Script

Usage: backup_files.sh [OPTION]

Options:
  -h, --help     Show this help
  -s, --size     Show backup directory size  
  -l, --list     List backups (newest first)
  
Environment Variables:
  BACKUP_HOME      Backup directory (default: ~/backups)
  BACKUP_RETENTION Days to keep backups (default: 30)

Configuration:
  Edit IMPORTANT_FILES array in script for custom files.
EOF
}

# Optimized argument parsing
case "${1:-}" in
    -h|--help) show_help; exit 0 ;;
    -s|--size) show_size; exit 0 ;;
    -l|--list) list_backups; exit 0 ;;
    "") run_backup ;;
    *) echo "Unknown option: $1. Use -h for help." >&2; exit 1 ;;
esac
