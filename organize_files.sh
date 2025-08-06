#!/bin/bash

# Ultra-Optimized File Organization Script
# Maximum performance with minimal resource usage

set -euo pipefail

# Constants - readonly for compiler optimizations
readonly TARGET_DIR="${1:-$PWD}"
readonly DRY_RUN="${DRY_RUN:-}"
readonly DATED="${CREATE_DATED_SUBFOLDERS:-}"
readonly DATE_SUFFIX="${DATED:+/$(date +%Y-%m)}"

# Compact file mappings - single string lookup table
readonly EXTENSIONS="pdf:doc:docx:txt:rtf:odt:pages=Documents|xls:xlsx:csv:ods=Spreadsheets|jpg:jpeg:png:gif:bmp:tiff:svg:webp:raw:heic=Images|mp4:avi:mkv:mov:wmv:flv:webm:m4v=Videos|mp3:wav:flac:aac:ogg:m4a:wma=Audio|zip:rar:7z:tar:gz:bz2:xz=Archives|py:js:html:css:php:cpp:c:java:sh:bash:json:xml:yml:yaml=Code|exe:msi:deb:rpm:dmg:app:appimage=Programs"

# Global counters - single variables for speed
declare -i g_total=0 g_moved=0 g_skip=0 g_dirs=0

# Pre-compiled regex for extension extraction
readonly EXT_REGEX='\.([^./]+)$'

# Fast extension extraction using parameter expansion
get_ext() {
    local f="$1"
    [[ "$f" =~ $EXT_REGEX && "${f:0:1}" != "." ]] && printf '%s' "${BASH_REMATCH[1],,}"
}

# Ultra-fast category lookup using string search
get_cat() {
    local ext="$1" match
    
    # Single pass through extension mappings
    while IFS='=' read -r exts cat; do
        case ":$exts:" in *":$ext:"*) printf '%s' "$cat"; return;; esac
    done <<< "${EXTENSIONS//|/$'\n'}"
    
    printf 'Misc'
}

# Optimized directory creation with caching
declare -A dir_cache=()
mk_dir() {
    local cat="$1"
    local path="$TARGET_DIR/$cat$DATE_SUFFIX"
    
    # Check cache first
    [[ -n "${dir_cache[$path]:-}" ]] && { printf '%s' "$path"; return; }
    
    if [[ ! -d "$path" ]]; then
        [[ -n "$DRY_RUN" ]] && printf '[DRY] mkdir %s\n' "$path" >&2 || {
            mkdir -p "$path" && ((g_dirs++))
        }
    fi
    
    dir_cache["$path"]=1
    printf '%s' "$path"
}

# Streamlined file processing
proc_file() {
    local f="$1" base ext cat dest
    
    ((g_total++))
    
    # Fast basename extraction
    base="${f##*/}"
    
    # Skip checks - combined for efficiency
    [[ "${base:0:1}" == "." || "$f" -ef "$0" ]] && { ((g_skip++)); return; }
    
    # Extract extension
    ext=$(get_ext "$base") || { ((g_skip++)); return; }
    
    # Get category and destination  
    cat=$(get_cat "$ext")
    dest="$(mk_dir "$cat")/$base"
    
    # Conflict check
    [[ -e "$dest" ]] && { 
        printf '[CONFLICT] %s exists\n' "$dest" >&2
        ((g_skip++))
        return
    }
    
    # Move operation
    if [[ -n "$DRY_RUN" ]]; then
        printf '[DRY] %s → %s\n' "$base" "$cat" >&2
    else
        mv "$f" "$dest" && {
            printf '[OK] %s → %s\n' "$base" "$cat" >&2
            ((g_moved++))
        }
    fi
}

# High-performance file iteration
organize() {
    printf 'Organizing: %s\n' "$TARGET_DIR" >&2
    [[ -n "$DRY_RUN" ]] && printf '[DRY RUN MODE]\n' >&2
    
    # Process files in single loop - no external processes
    shopt -s nullglob dotglob
    local files=("$TARGET_DIR"/*)
    shopt -u nullglob dotglob
    
    for f in "${files[@]}"; do
        [[ -f "$f" ]] && proc_file "$f"
    done
}

# Compact statistics
stats() {
    printf '\nStats: %d total, %d moved, %d skipped, %d dirs\n' "$g_total" "$g_moved" "$g_skip" "$g_dirs"
    [[ -n "$DRY_RUN" ]] && printf 'DRY RUN - no changes made\n'
}

# Minimal file type listing
list_types() {
    printf 'File Types:\n%s\n' "${EXTENSIONS//[:|]/  }" | tr '=' '\n' | sort
}

# Fast file preview
preview() {
    printf 'Files to organize:\n'
    shopt -s nullglob
    for f in "$TARGET_DIR"/*; do
        [[ -f "$f" ]] || continue
        local base="${f##*/}" ext cat
        [[ "${base:0:1}" == "." ]] && continue
        ext=$(get_ext "$base") || continue
        cat=$(get_cat "$ext")
        printf '%-25s → %s\n' "$base" "$cat"
    done
    shopt -u nullglob
}

# Minimal help
help() {
    cat << 'EOF'
Ultra-Fast File Organizer

Usage: organize.sh [DIR] [OPTION]

Options:
  -d    Dry run (preview)
  -t    Show file types  
  -l    List files
  -h    This help

Environment:
  DRY_RUN=1                 Dry run mode
  CREATE_DATED_SUBFOLDERS=1 Use YYYY-MM subfolders

Examples:
  organize.sh              # Organize current dir
  organize.sh ~/Downloads  # Organize Downloads  
  DRY_RUN=1 organize.sh -d # Preview changes
EOF
}

# Ultra-fast argument parsing
case "${2:-${1:---organize}}" in
    -h|--help) help ;;
    -t|--types) list_types ;;  
    -l|--list) preview ;;
    -d|--dry-run) DRY_RUN=1 organize; stats ;;
    --organize) organize; stats ;;
    *) 
        if [[ -d "${1:-}" ]]; then
            organize; stats
        else
            printf 'Invalid directory: %s\n' "${1:-}" >&2
            exit 1
        fi
        ;;
esac
