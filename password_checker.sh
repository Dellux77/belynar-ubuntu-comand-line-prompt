#!/bin/bash

# Optimized Password Strength Checker - String length and conditionals

# Colors
G='\033[0;32m' R='\033[0;31m' Y='\033[1;33m' C='\033[0;36m' B='\033[1m' NC='\033[0m'

# Weakness patterns (consolidated)
declare -A weak=(
    [123]="sequence" [abc]="sequence" [qwe]="keyboard" [password]="common"
    [admin]="common" [login]="common" [test]="common" [user]="common"
)

# Character validation (bitwise flags for efficiency)
check_chars() {
    local pwd=$1 flags=0
    [[ $pwd =~ [a-z] ]] && ((flags |= 1))
    [[ $pwd =~ [A-Z] ]] && ((flags |= 2))
    [[ $pwd =~ [0-9] ]] && ((flags |= 4))
    [[ $pwd =~ [^a-zA-Z0-9] ]] && ((flags |= 8))
    echo $flags
}

# Pattern detection
find_issues() {
    local pwd=$(echo "$1" | tr '[:upper:]' '[:lower:]') issues=0
    
    # Repetitive chars
    [[ $pwd =~ (.)\1{2,} ]] && ((issues++))
    
    # Weak patterns
    for pattern in "${!weak[@]}"; do
        [[ $pwd == *$pattern* ]] && ((issues++)) && break
    done
    
    # Sequences (optimized check)
    case $pwd in
        *012*|*234*|*456*|*678*|*890*|*987*|*876*|*765*|*654*|*543*|*432*|*321*|*210*|*qwerty*|*asdf*|*zxcv*)
            ((issues++)) ;;
    esac
    
    echo $issues
}

# Strength calculation
strength() {
    local pwd=$1 len=${#pwd}
    local score=0 flags=$(check_chars "$pwd") issues=$(find_issues "$pwd")
    
    # Length scoring (optimized ranges)
    case $len in
        [1-7]) score=0 ;;
        [8-11]) score=25 ;;
        [12-15]) score=50 ;;
        *) score=75 ;;
    esac
    
    # Character bonuses (bitwise check)
    ((flags & 1)) && ((score += 5))  # lowercase
    ((flags & 2)) && ((score += 5))  # uppercase
    ((flags & 4)) && ((score += 5))  # digits
    ((flags & 8)) && ((score += 10)) # special
    
    # Pattern penalties
    ((score -= issues * 15))
    [[ $score -lt 0 ]] && score=0
    
    echo "$score:$flags:$issues"
}

# Visual output
show_strength() {
    local score=$1 flags=$2 issues=$3
    
    # Strength bar
    local bars=$((score / 10)) color
    case $score in
        [0-39]) color=$R ;;
        [40-69]) color=$Y ;;
        [70-89]) color=$C ;;
        *) color=$G ;;
    esac
    
    printf "${color}"
    for ((i=0; i<bars; i++)); do printf "█"; done
    for ((i=bars; i<10; i++)); do printf "░"; done
    printf "${NC} "
    
    # Rating
    case $score in
        [0-39]) echo "${R}Weak${NC}" ;;
        [40-69]) echo "${Y}Fair${NC}" ;;
        [70-89]) echo "${C}Good${NC}" ;;
        *) echo "${G}Strong${NC}" ;;
    esac
}

# Analysis output
analyze() {
    local pwd=$1
    local result=$(strength "$pwd")
    IFS=':' read -r score flags issues <<< "$result"
    
    echo -e "${B}Length:${NC} ${#pwd} | ${B}Score:${NC} $score/100"
    show_strength $score $flags $issues
    
    # Suggestions (only if weak)
    if [[ $score -lt 70 ]]; then
        local tips=()
        [[ ${#pwd} -lt 12 ]] && tips+=("longer")
        ((flags & 1)) || tips+=("lowercase")
        ((flags & 2)) || tips+=("uppercase")
        ((flags & 4)) || tips+=("numbers")
        ((flags & 8)) || tips+=("symbols")
        [[ $issues -gt 0 ]] && tips+=("avoid patterns")
        
        [[ ${#tips[@]} -gt 0 ]] && echo -e "${Y}Need: $(IFS=', '; echo "${tips[*]}")${NC}"
    fi
}

# Batch mode
batch() {
    local count=0
    echo "Enter passwords (empty to finish):"
    
    while read -s -p "$((++count)). " pwd && [[ -n $pwd ]]; do
        echo
        local result=$(strength "$pwd")
        local score=${result%%:*}
        printf "%3d/100 " $score
        show_strength $score ${result#*:}
        echo
    done
    
    [[ $count -eq 1 ]] && echo "No passwords entered"
}

# Main function
main() {
    case ${1:-""} in
        -h|--help)
            echo "Usage: $0 [password] | -b | -h"
            echo "Options: -b (batch), -h (help)"
            ;;
        -b|--batch) batch ;;
        "")
            read -s -p "Password: " pwd
            echo
            [[ -n $pwd ]] && analyze "$pwd" || echo "No input"
            ;;
        *)
            echo -e "${Y}Warning: Password visible in history${NC}" >&2
            analyze "$1"
            ;;
    esac
}

main "$@"
